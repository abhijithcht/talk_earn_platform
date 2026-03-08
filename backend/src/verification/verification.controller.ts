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
import { VerificationService } from './verification.service';

@ApiTags('Verification')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('verification')
export class VerificationController {
  constructor(private readonly verificationService: VerificationService) {}

  @Post('submit')
  @ApiOperation({ summary: 'Submit ID verification (id_hash + date of birth)' })
  submit(
    @Request() req: RequestWithUser,
    @Body() body: { idHash: string; dateOfBirth: string },
  ) {
    return this.verificationService.submit(
      req.user.id,
      body.idHash,
      new Date(body.dateOfBirth),
    );
  }

  @Get('status')
  @ApiOperation({ summary: 'Check verification status' })
  getStatus(@Request() req: RequestWithUser) {
    return this.verificationService.getStatus(req.user.id);
  }
}
