import { Controller, Get, Res } from '@nestjs/common';
import { ApiExcludeEndpoint } from '@nestjs/swagger';
import type { Response } from 'express';

@Controller()
export class AppController {
  @Get()
  @ApiExcludeEndpoint()
  getHello(): string {
    return 'Talk & Earn API is running. Visit /api for Swagger documentation.';
  }

  @Get('favicon.ico')
  @ApiExcludeEndpoint()
  getFavicon(@Res({ passthrough: true }) res: Response) {
    res.status(204).send();
  }
}
