import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';

import { Transaction as TransEntity } from '../entities/transaction.entity';
import { User } from '../entities/user.entity';
import { Wallet } from '../entities/wallet.entity';
import { EarnDto } from './dto/earn.dto';
import { WithdrawDto } from './dto/withdraw.dto';

@Injectable()
export class WalletService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Wallet)
    private readonly walletRepository: Repository<Wallet>,
    @InjectRepository(TransEntity)
    private readonly transactionRepository: Repository<TransEntity>,
    private readonly configService: ConfigService,
    private readonly dataSource: DataSource,
  ) {}

  async getBalance(userId: number) {
    const wallet = await this.walletRepository.findOneBy({ userId });
    if (!wallet) {
      throw new NotFoundException('Wallet not found');
    }
    return { balance: wallet.balance };
  }

  async earn(userId: number, dto: EarnDto) {
    const wallet = await this.walletRepository.findOneBy({ userId });
    if (!wallet) {
      throw new NotFoundException('Wallet not found');
    }

    const rates: Record<string, string> = {
      text: 'TEXT_COINS_PER_MIN',
      audio: 'AUDIO_COINS_PER_MIN',
      video: 'VIDEO_COINS_PER_MIN',
    };

    const ratePerMin = parseInt(
      this.configService.get<string>(rates[dto.medium], '1'),
      10,
    );
    const coinsEarned = dto.minutes * ratePerMin;

    // Tiered Bonus logic for high and low ratings (parity with Python)
    const user = await this.userRepository.findOneBy({ id: userId });
    let finalCoins = coinsEarned;
    if (user) {
      if (user.rating >= 4.8) {
        finalCoins += Math.floor(coinsEarned * 0.5); // 50% massive bonus
      } else if (user.rating >= 4.0) {
        finalCoins += Math.floor(coinsEarned * 0.2); // 20% good bonus
      } else if (user.rating < 3.0) {
        finalCoins -= Math.floor(coinsEarned * 0.2); // 20% penalty
      }
    }

    await this.walletRepository.increment({ userId }, 'balance', finalCoins);
    const updatedWallet = await this.walletRepository.findOneBy({ userId });

    // Record transaction
    const transaction = this.transactionRepository.create({
      userId,
      coins: finalCoins,
      type: 'earn',
      status: 'completed',
    });
    await this.transactionRepository.save(transaction);

    return {
      message: 'Coins added',
      balance: updatedWallet?.balance || wallet.balance + finalCoins,
    };
  }

  async withdraw(userId: number, dto: WithdrawDto) {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Quality Control Limits (parity with Python)
    if (user.rating < 3.0 || user.withdrawalBlocked) {
      throw new BadRequestException(
        'Withdrawals blocked due to low rating (<3.0) or moderation.',
      );
    }

    // Minimum withdrawal limit (parity with Python)
    if (dto.coins < 100) {
      throw new BadRequestException('Minimum withdrawal is 100 coins ($1).');
    }

    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const wallet = await queryRunner.manager.findOne(Wallet, {
        where: { userId },
        lock: { mode: 'pessimistic_write' },
      });

      if (!wallet) {
        throw new NotFoundException('Wallet not found');
      }

      if (wallet.balance < dto.coins) {
        throw new BadRequestException('Insufficient balance');
      }

      wallet.balance -= dto.coins;
      await queryRunner.manager.save(wallet);

      const usdAmount = dto.coins / 100;

      const transaction = queryRunner.manager.create(TransEntity, {
        userId,
        coins: -dto.coins,
        type: 'withdraw',
        status: 'pending',
        payoutProvider: 'stripe',
      });
      await queryRunner.manager.save(transaction);

      await queryRunner.commitTransaction();

      // TODO: Integrate actual Stripe/Razorpay payout

      return {
        message: 'Withdrawal initiated',
        coins_deducted: dto.coins,
        usd_amount: usdAmount,
        balance: wallet.balance,
      };
    } catch (err) {
      await queryRunner.rollbackTransaction();
      throw err;
    } finally {
      await queryRunner.release();
    }
  }
}
