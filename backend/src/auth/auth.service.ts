import {
    BadRequestException,
    Injectable,
    UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import * as bcrypt from 'bcrypt';
import { Repository } from 'typeorm';

import { User } from '../entities/user.entity';
import { Wallet } from '../entities/wallet.entity';
import { MailService } from '../mail/mail.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { VerifyEmailDto } from './dto/verify-email.dto';
import { ResponseHelper } from '../common/helpers/response.helper';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Wallet)
    private readonly walletRepository: Repository<Wallet>,
    private readonly mailService: MailService,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async register(dto: RegisterDto) {
    const existing = await this.userRepository.findOneBy({ email: dto.email });
    if (existing) {
      throw new BadRequestException('Email already registered');
    }

    const hashedPassword = await bcrypt.hash(dto.password, 10);
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();

    const user = this.userRepository.create({
      email: dto.email,
      hashedPassword,
      fullName: dto.fullName ?? null,
      gender: dto.gender ?? null,
      genderPreference: dto.genderPreference ?? 'any',
      otpCode,
    });
    const savedUser = await this.userRepository.save(user);

    // Create wallet for user
    const wallet = this.walletRepository.create({ userId: savedUser.id });
    await this.walletRepository.save(wallet);

    // Send OTP via email
    await this.mailService.sendOtp(dto.email, otpCode);

    return ResponseHelper.success('Registered. Please verify your email.');
  }

  async login(dto: LoginDto) {
    const user = await this.userRepository.findOneBy({ email: dto.email });

    if (!user) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const isMatch = await bcrypt.compare(dto.password, user.hashedPassword);
    if (!isMatch) {
      throw new UnauthorizedException('Invalid email or password');
    }

    if (!user.isEmailVerified) {
      throw new UnauthorizedException(
        'Email not verified. Check your inbox for OTP.',
      );
    }

    const payload = { sub: user.id, email: user.email };
    const accessToken = this.jwtService.sign(payload);

    return ResponseHelper.success('Login successful', {
      access_token: accessToken,
      token_type: 'bearer',
    });
  }

  async verifyEmail(dto: VerifyEmailDto) {
    const user = await this.userRepository.findOneBy({ email: dto.email });

    if (!user) {
      throw new BadRequestException('User not found');
    }

    if (user.otpCode !== dto.otpCode) {
      throw new BadRequestException('Invalid OTP code');
    }

    user.isEmailVerified = true;
    user.otpCode = null;
    await this.userRepository.save(user);

    return ResponseHelper.success('Email verified successfully');
  }
}
