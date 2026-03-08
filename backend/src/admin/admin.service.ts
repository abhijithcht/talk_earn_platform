import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { AuditLog } from '../entities/audit-log.entity';
import { BannedId } from '../entities/banned-id.entity';
import { User } from '../entities/user.entity';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(AuditLog)
    private readonly auditLogRepository: Repository<AuditLog>,
    @InjectRepository(BannedId)
    private readonly bannedIdRepository: Repository<BannedId>,
  ) {}

  async getPendingVerifications() {
    return this.userRepository.find({
      where: { verificationStatus: 'pending' },
      select: [
        'id',
        'email',
        'fullName',
        'gender',
        'dateOfBirth',
        'verificationStatus',
        'createdAt',
      ],
    });
  }

  async approveVerification(adminId: number, userId: number) {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    user.verificationStatus = 'verified';
    user.isVerified = true;
    await this.userRepository.save(user);

    const audit = this.auditLogRepository.create({
      adminId,
      targetUserId: userId,
      action: 'verification_approved',
    });
    await this.auditLogRepository.save(audit);

    return { message: 'User verification approved' };
  }

  async rejectVerification(adminId: number, userId: number) {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    user.verificationStatus = 'rejected';
    await this.userRepository.save(user);

    const audit = this.auditLogRepository.create({
      adminId,
      targetUserId: userId,
      action: 'verification_rejected',
    });
    await this.auditLogRepository.save(audit);

    return { message: 'User verification rejected' };
  }

  async banUser(adminId: number, userId: number, reason?: string) {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    user.isActive = false;
    await this.userRepository.save(user);

    if (user.idHash) {
      const bannedId = this.bannedIdRepository.create({
        idHash: user.idHash,
        reason: reason || 'Admin ban',
      });
      await this.bannedIdRepository.save(bannedId);
    }

    const audit = this.auditLogRepository.create({
      adminId,
      targetUserId: userId,
      action: 'user_banned',
      details: reason,
    });
    await this.auditLogRepository.save(audit);

    return { message: 'User banned' };
  }
}
