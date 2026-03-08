import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SessionRecord } from '../entities/session.entity';
import { User } from '../entities/user.entity';
import { RatingController } from './rating.controller';
import { RatingService } from './rating.service';

@Module({
  imports: [TypeOrmModule.forFeature([User, SessionRecord])],
  providers: [RatingService],
  controllers: [RatingController],
})
export class RatingModule {}
