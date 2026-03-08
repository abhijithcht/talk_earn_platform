import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SessionRecord } from '../entities/session.entity';
import { User } from '../entities/user.entity';
import { SubmitRatingDto } from './dto/submit-rating.dto';

@Injectable()
export class RatingService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(SessionRecord)
    private readonly sessionRepository: Repository<SessionRecord>,
  ) {}

  async submitRating(callerId: number, dto: SubmitRatingDto) {
    if (callerId === dto.targetUserId) {
      throw new BadRequestException('You cannot rate yourself');
    }

    const targetUser = await this.userRepository.findOne({
      where: { id: dto.targetUserId },
    });

    if (!targetUser) {
      throw new NotFoundException('Target user not found');
    }

    // In a full-scale app, we would sum the SessionRecords.
    // For now, we mathematically roll the average slightly towards the new score
    // Assumes rating is a number, defaults to 0 or 5.0
    const currentRating =
      typeof targetUser.rating === 'number' ? targetUser.rating : 5.0;

    // Convert to number strictly to perform math without concatenating
    const newRating = Number(
      (Number(currentRating) * 0.9 + dto.score * 0.1).toFixed(2),
    );
    targetUser.rating = newRating;

    await this.userRepository.save(targetUser);

    // Create a SessionRecord to log the interaction (parity with Python)
    const session = this.sessionRepository.create({
      callerId,
      calleeId: dto.targetUserId,
      sessionType: 'chat', // Default for now, matched sessions use MatchService
      rating: dto.score,
      durationMinutes: 1, // Minimum logged duration
    });
    await this.sessionRepository.save(session);

    return {
      message: 'Rating submitted successfully',
      new_average: targetUser.rating,
    };
  }
}
