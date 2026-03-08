import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { AuditLog } from '../entities/audit-log.entity';
import { BannedId } from '../entities/banned-id.entity';
import { User } from '../entities/user.entity';
import { Warning } from '../entities/warning.entity';

@Injectable()
export class ModerationService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Warning)
    private readonly warningRepository: Repository<Warning>,
    @InjectRepository(AuditLog)
    private readonly auditLogRepository: Repository<AuditLog>,
    @InjectRepository(BannedId)
    private readonly bannedIdRepository: Repository<BannedId>,
  ) {}

  async warnUser(adminId: number, targetUserId: number, reason: string) {
    const target = await this.userRepository.findOneBy({ id: targetUserId });
    if (!target) {
      throw new NotFoundException('User not found');
    }

    target.warnings += 1;
    let level: string;

    if (target.warnings === 1) {
      level = 'reminder';
    } else if (target.warnings === 2) {
      level = 'freeze';
      target.isActive = false;
    } else {
      level = 'ban';
      target.isActive = false;

      // Add to banned IDs if they have an ID hash
      if (target.idHash) {
        const bannedId = this.bannedIdRepository.create({
          idHash: target.idHash,
          reason: `Level 3 ban: ${reason}`,
        });
        await this.bannedIdRepository.save(bannedId);
      }
    }

    await this.userRepository.save(target);

    const warning = this.warningRepository.create({
      userId: targetUserId,
      level,
      reason,
    });
    await this.warningRepository.save(warning);

    // Audit log
    const audit = this.auditLogRepository.create({
      adminId,
      targetUserId,
      action: `warning_${level}`,
      details: reason,
    });
    await this.auditLogRepository.save(audit);

    return {
      message: `Warning issued (${level})`,
      warning_count: target.warnings,
      level,
    };
  }

  async appealWarning(userId: number, warningId: number) {
    const warning = await this.warningRepository.findOneBy({ id: warningId });
    if (!warning) {
      throw new NotFoundException('Warning not found');
    }

    if (warning.userId !== userId) {
      throw new BadRequestException('You can only appeal your own warnings');
    }

    warning.appealed = true;
    await this.warningRepository.save(warning);

    return { message: 'Appeal submitted for review' };
  }
}
