import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { AuditLog } from '../entities/audit-log.entity';
import { BannedId } from '../entities/banned-id.entity';
import { User } from '../entities/user.entity';
import { ResponseHelper } from '../common/helpers/response.helper';

@Injectable()
export class VerificationService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(BannedId)
    private readonly bannedIdRepository: Repository<BannedId>,
    @InjectRepository(AuditLog)
    private readonly auditLogRepository: Repository<AuditLog>,
  ) {}

  async submit(userId: number, idHash: string, dateOfBirth: Date) {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Check if ID hash is blacklisted (parity with Python)
    const banned = await this.bannedIdRepository.findOneBy({ idHash });
    if (banned) {
      throw new ForbiddenException('This ID is blacklisted.');
    }

    user.idHash = idHash;
    user.dateOfBirth = dateOfBirth;
    user.verificationStatus = 'pending';
    await this.userRepository.save(user);

    // Log the action to Audit Log (parity with Python)
    const audit = this.auditLogRepository.create({
      targetUserId: userId,
      action: 'verification_submitted',
      details: 'User uploaded ID and selfie for verification',
    });
    await this.auditLogRepository.save(audit);

    return ResponseHelper.success('Verification submitted. Awaiting admin review.');
  }

  async getStatus(userId: number) {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    return ResponseHelper.success('Verification status retrieved', {
      verification_status: user.verificationStatus,
      is_verified: user.isVerified,
    });
  }
}
