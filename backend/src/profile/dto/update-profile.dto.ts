import { IsInt, IsOptional, IsString } from 'class-validator';

export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  fullName?: string;

  @IsOptional()
  @IsString()
  gender?: string;

  @IsOptional()
  @IsString()
  genderPreference?: string;

  @IsOptional()
  @IsInt()
  avatarId?: number;

  @IsOptional()
  @IsString()
  customizations?: string;

  @IsOptional()
  @IsString()
  interests?: string;
}
