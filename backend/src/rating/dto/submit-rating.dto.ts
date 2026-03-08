import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsNotEmpty, Max, Min } from 'class-validator';

export class SubmitRatingDto {
  @ApiProperty({ example: 2, description: 'ID of the user being rated' })
  @IsNotEmpty()
  @IsInt()
  targetUserId: number;

  @ApiProperty({ example: 4, description: 'Rating score (1 to 5)' })
  @IsInt()
  @Min(1)
  @Max(5)
  score: number;
}
