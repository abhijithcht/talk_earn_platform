import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';

import { AdminModule } from './admin/admin.module';
import { AuthModule } from './auth/auth.module';
import { ChatModule } from './chat/chat.module';
import { MatchModule } from './match/match.module';
import { ModerationModule } from './moderation/moderation.module';
import { ProfileModule } from './profile/profile.module';
import { VerificationModule } from './verification/verification.module';
import { WalletModule } from './wallet/wallet.module';

import { AppController } from './app.controller';
import { MailModule } from './mail/mail.module';
import { RatingModule } from './rating/rating.module';

@Module({
  imports: [
    // Load .env file globally
    ConfigModule.forRoot({ isGlobal: true }),

    // TypeORM PostgreSQL connection
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get<string>('DB_HOST', 'localhost'),
        port: configService.get<number>('DB_PORT', 5432),
        username: configService.get<string>('DB_USERNAME', 'postgres'),
        password: configService.get<string>('DB_PASSWORD', ''),
        database: configService.get<string>('DB_NAME', 'talk_earn'),
        entities: [__dirname + '/entities/*.entity{.ts,.js}'],
        synchronize: true, // Auto-create tables (disable in production)
      }),
    }),

    // Feature modules
    AuthModule,
    MailModule,
    WalletModule,
    ProfileModule,
    MatchModule,
    ChatModule,
    VerificationModule,
    ModerationModule,
    AdminModule,
    RatingModule,
  ],
  controllers: [AppController],
})
export class AppModule {}
