import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import {
  Body,
  Controller,
  Get,
  Post,
  Request,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { EarnDto } from './dto/earn.dto';
import { WithdrawDto } from './dto/withdraw.dto';
import { WalletService } from './wallet.service';

@ApiTags('Wallet')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('wallet')
export class WalletController {
  constructor(private readonly walletService: WalletService) {}

  @Get('balance')
  @ApiOperation({ summary: 'Get current coin balance' })
  getBalance(@Request() req: RequestWithUser) {
    return this.walletService.getBalance(req.user.id);
  }

  @Post('earn')
  @ApiOperation({ summary: 'Earn coins for call time' })
  earn(@Request() req: RequestWithUser, @Body() dto: EarnDto) {
    return this.walletService.earn(req.user.id, dto);
  }

  @Post('withdraw')
  @ApiOperation({ summary: 'Withdraw coins via payout provider (min 100)' })
  withdraw(@Request() req: RequestWithUser, @Body() dto: WithdrawDto) {
    return this.walletService.withdraw(req.user.id, dto);
  }
}
