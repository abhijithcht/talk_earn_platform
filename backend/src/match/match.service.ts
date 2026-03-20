import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import Redis from 'ioredis';
import { Repository } from 'typeorm';

import { SessionRecord } from '../entities/session.entity';
import { User } from '../entities/user.entity';
import { ResponseHelper } from '../common/helpers/response.helper';

interface QueueEntry {
  userId: number;
  gender: string | null;
  genderPreference: string;
  medium: string;
}

@Injectable()
export class MatchService {
  private readonly redis = new Redis(); // defaults to localhost:6379

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(SessionRecord)
    private readonly sessionRepository: Repository<SessionRecord>,
  ) {}

  async findMatch(userId: number, medium: string) {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) {
      throw new BadRequestException('User not found');
    }

    // Check if user is already in queue
    // Fetch queue from Redis
    const queueData = await this.redis.hgetall('matchQueue');
    const queueEntries: QueueEntry[] = Object.values(queueData).map(
      (v) => JSON.parse(v) as QueueEntry,
    );

    // Check if user is already in queue
    const existingIndex = queueEntries.findIndex(
      (entry) => entry.userId === userId,
    );
    if (existingIndex !== -1) {
      throw new BadRequestException('Already in matching queue');
    }

    // Try to find a match in the queue
    const matchIndex = queueEntries.findIndex((entry) => {
      const genderMatch =
        (user.genderPreference === 'any' ||
          user.genderPreference === entry.gender) &&
        (entry.genderPreference === 'any' ||
          entry.genderPreference === user.gender);
      return genderMatch && entry.medium === medium;
    });

    if (matchIndex !== -1) {
      const matched = queueEntries[matchIndex];

      // Atomically remove the match from the queue
      const deletedCount = await this.redis.hdel(
        'matchQueue',
        String(matched.userId),
      );

      if (deletedCount > 0) {
        // Create a session record
        const session = this.sessionRepository.create({
          callerId: userId,
          calleeId: matched.userId,
          sessionType: medium,
          durationMinutes: 0,
        });
        await this.sessionRepository.save(session);

        return ResponseHelper.success('Match found', {
          matched: true,
          session_id: session.id,
          partner_id: matched.userId,
        });
      }
    }

    // No match found, add to queue
    const entry: QueueEntry = {
      userId,
      gender: user.gender,
      genderPreference: user.genderPreference,
      medium,
    };
    await this.redis.hset('matchQueue', String(userId), JSON.stringify(entry));

    return ResponseHelper.success('Added to matching queue', { matched: false });
  }

  async cancelMatch(userId: number) {
    await this.redis.hdel('matchQueue', String(userId));
    return ResponseHelper.success('Matching cancelled');
  }
}
