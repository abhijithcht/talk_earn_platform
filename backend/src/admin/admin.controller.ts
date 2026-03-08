import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Request,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AdminGuard } from '../auth/guards/admin.guard';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AdminService } from './admin.service';

@ApiTags('Admin')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, AdminGuard)
@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('verifications/pending')
  @ApiOperation({ summary: 'List pending verifications (admin only)' })
  getPendingVerifications() {
    return this.adminService.getPendingVerifications();
  }

  @Post('verifications/:userId/approve')
  @ApiOperation({ summary: 'Approve user verification (admin only)' })
  approveVerification(
    @Request() req: RequestWithUser,
    @Param('userId', ParseIntPipe) userId: number,
  ) {
    return this.adminService.approveVerification(req.user.id, userId);
  }

  @Post('verifications/:userId/reject')
  @ApiOperation({ summary: 'Reject user verification (admin only)' })
  rejectVerification(
    @Request() req: RequestWithUser,
    @Param('userId', ParseIntPipe) userId: number,
  ) {
    return this.adminService.rejectVerification(req.user.id, userId);
  }

  @Post('ban/:userId')
  @ApiOperation({ summary: 'Ban a user (admin only)' })
  banUser(
    @Request() req: RequestWithUser,
    @Param('userId', ParseIntPipe) userId: number,
    @Body() body: { reason?: string },
  ) {
    return this.adminService.banUser(req.user.id, userId, body.reason);
  }
}
