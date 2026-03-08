import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import {
  Body,
  Controller,
  Delete,
  Get,
  Post,
  Put,
  Request,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiBearerAuth,
  ApiConsumes,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ChangePasswordDto } from './dto/change-password.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { ProfileService } from './profile.service';

@ApiTags('Profile')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('profile')
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  @Get('me')
  @ApiOperation({ summary: 'Get current user profile' })
  getMe(@Request() req: RequestWithUser) {
    return this.profileService.getMe(req.user.id);
  }

  @Put('update')
  @ApiOperation({ summary: 'Update profile (name, gender, preferences, etc.)' })
  updateProfile(
    @Request() req: RequestWithUser,
    @Body() dto: UpdateProfileDto,
  ) {
    return this.profileService.updateProfile(req.user.id, dto);
  }

  @Get('avatars')
  @ApiOperation({ summary: 'List available avatars' })
  listAvatars() {
    return this.profileService.listAvatars();
  }

  @Post('picture')
  @ApiOperation({ summary: 'Upload profile picture (multipart)' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: './uploads',
        filename: (_req, file, cb) => {
          const uniqueSuffix =
            Date.now() + '-' + Math.round(Math.random() * 1e9);
          cb(null, `profile-${uniqueSuffix}${extname(file.originalname)}`);
        },
      }),
    }),
  )
  uploadPicture(
    @Request() req: RequestWithUser,
    @UploadedFile() file: Express.Multer.File,
  ) {
    return this.profileService.uploadPicture(
      req.user.id,
      `/uploads/${file.filename}`,
    );
  }

  @Post('change-password')
  @ApiOperation({ summary: 'Change password' })
  changePassword(
    @Request() req: RequestWithUser,
    @Body() dto: ChangePasswordDto,
  ) {
    return this.profileService.changePassword(req.user.id, dto);
  }

  @Delete('delete-account')
  @ApiOperation({ summary: 'Delete account' })
  deleteAccount(
    @Request() req: RequestWithUser,
    @Body() body: { currentPassword: string },
  ) {
    return this.profileService.deleteAccount(req.user.id, body.currentPassword);
  }
}
