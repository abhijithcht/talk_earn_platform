import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import { Body, Controller, Post, Request, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { SubmitRatingDto } from './dto/submit-rating.dto';
import { RatingService } from './rating.service';

@ApiTags('Rating')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('rating')
export class RatingController {
  constructor(private readonly ratingService: RatingService) {}

  @Post('submit')
  @ApiOperation({ summary: 'Submit a rating for a user after a call' })
  submitRating(@Request() req: RequestWithUser, @Body() dto: SubmitRatingDto) {
    return this.ratingService.submitRating(req.user.id, dto);
  }
}
