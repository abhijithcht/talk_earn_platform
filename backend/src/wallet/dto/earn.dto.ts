import { IsIn, IsInt, IsString, Min } from 'class-validator';

export class EarnDto {
  @IsInt()
  @Min(1)
  minutes: number;

  @IsString()
  @IsIn(['text', 'audio', 'video'])
  medium: string;
}
