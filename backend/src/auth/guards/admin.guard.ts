import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import type { RequestWithUser } from '../../common/interfaces/request-with-user.interface';
import { User } from '../../entities/user.entity';

@Injectable()
export class AdminGuard implements CanActivate {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<RequestWithUser>();
    const userId = request.user?.id;

    if (!userId) {
      throw new ForbiddenException('Not authenticated');
    }

    const user = await this.userRepository.findOneBy({ id: userId });

    if (!user?.isSuperuser) {
      throw new ForbiddenException('Admin access required');
    }

    return true;
  }
}
