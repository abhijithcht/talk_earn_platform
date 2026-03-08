import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from '../auth/auth.module';
import { AuditLog } from '../entities/audit-log.entity';
import { BannedId } from '../entities/banned-id.entity';
import { User } from '../entities/user.entity';
import { Warning } from '../entities/warning.entity';
import { ModerationController } from './moderation.controller';
import { ModerationService } from './moderation.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([User, Warning, AuditLog, BannedId]),
    AuthModule,
  ],
  controllers: [ModerationController],
  providers: [ModerationService],
  exports: [ModerationService],
})
export class ModerationModule {}
