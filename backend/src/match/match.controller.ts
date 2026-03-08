import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import { Body, Controller, Post, Request, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { MatchService } from './match.service';

@ApiTags('Match')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('match')
export class MatchController {
  constructor(private readonly matchService: MatchService) {}

  @Post('find')
  @ApiOperation({ summary: 'Enter matching queue' })
  findMatch(@Request() req: RequestWithUser, @Body() body: { medium: string }) {
    return this.matchService.findMatch(req.user.id, body.medium);
  }

  @Post('cancel')
  @ApiOperation({ summary: 'Cancel matching' })
  cancelMatch(@Request() req: RequestWithUser) {
    return this.matchService.cancelMatch(req.user.id);
  }
}
