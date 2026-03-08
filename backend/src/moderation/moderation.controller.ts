import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import {
  Body,
  Controller,
  Param,
  ParseIntPipe,
  Post,
  Request,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AdminGuard } from '../auth/guards/admin.guard';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ModerationService } from './moderation.service';

@ApiTags('Moderation')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('moderation')
export class ModerationController {
  constructor(private readonly moderationService: ModerationService) {}

  @Post('warn/:userId')
  @UseGuards(AdminGuard)
  @ApiOperation({ summary: 'Issue warning to user (admin only)' })
  warnUser(
    @Request() req: RequestWithUser,
    @Param('userId', ParseIntPipe) userId: number,
    @Body() body: { reason: string },
  ) {
    return this.moderationService.warnUser(req.user.id, userId, body.reason);
  }

  @Post('appeal/:warningId')
  @ApiOperation({ summary: 'Appeal a warning' })
  appealWarning(
    @Request() req: RequestWithUser,
    @Param('warningId', ParseIntPipe) warningId: number,
  ) {
    return this.moderationService.appealWarning(req.user.id, warningId);
  }
}
