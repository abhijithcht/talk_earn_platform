import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import * as bcrypt from 'bcrypt';
import { Repository } from 'typeorm';

import { Avatar } from '../entities/avatar.entity';
import { User } from '../entities/user.entity';
import { ChangePasswordDto } from './dto/change-password.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';

@Injectable()
export class ProfileService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Avatar)
    private readonly avatarRepository: Repository<Avatar>,
  ) {}

  async getMe(userId: number) {
    const user = await this.userRepository.findOne({
      where: { id: userId },
      relations: ['avatar', 'wallet'],
    });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Strip sensitive fields
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { hashedPassword, otpCode, ...profile } = user;
    return profile;
  }

  async updateProfile(userId: number, dto: UpdateProfileDto) {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    if (dto.fullName !== undefined) user.fullName = dto.fullName;
    if (dto.gender !== undefined) user.gender = dto.gender;
    if (dto.genderPreference !== undefined)
      user.genderPreference = dto.genderPreference;
    if (dto.avatarId !== undefined) user.avatar_id = dto.avatarId;
    if (dto.customizations !== undefined)
      user.customizations = dto.customizations;
    if (dto.interests !== undefined) user.interests = dto.interests;

    await this.userRepository.save(user);
    return { message: 'Profile updated' };
  }

  async listAvatars() {
    return this.avatarRepository.find();
  }

  async uploadPicture(userId: number, filePath: string) {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    user.profilePictureUrl = filePath;
    await this.userRepository.save(user);

    return { message: 'Profile picture updated', url: filePath };
  }

  async changePassword(userId: number, dto: ChangePasswordDto) {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    const isMatch = await bcrypt.compare(
      dto.currentPassword,
      user.hashedPassword,
    );
    if (!isMatch) {
      throw new BadRequestException('Current password is incorrect');
    }

    user.hashedPassword = await bcrypt.hash(dto.newPassword, 10);
    await this.userRepository.save(user);

    return { message: 'Password changed successfully' };
  }

  async deleteAccount(userId: number, currentPassword: string) {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    const isMatch = await bcrypt.compare(currentPassword, user.hashedPassword);
    if (!isMatch) {
      throw new BadRequestException('Password is incorrect');
    }

    await this.userRepository.remove(user);
    return { message: 'Account deleted' };
  }
}
