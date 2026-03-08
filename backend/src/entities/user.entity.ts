import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Avatar } from './avatar.entity';
import { Wallet } from './wallet.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 255, unique: true })
  email: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  fullName: string | null;

  @Column({ type: 'varchar', length: 512 })
  hashedPassword: string;

  // ── Base flags ──
  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @Column({ type: 'boolean', default: false })
  isVerified: boolean;

  @Column({ type: 'boolean', default: false })
  isSuperuser: boolean;

  // ── Email OTP ──
  @Column({ type: 'boolean', default: false })
  isEmailVerified: boolean;

  @Column({ type: 'varchar', length: 16, nullable: true })
  otpCode: string | null;

  // ── Verification & Compliance ──
  @Column({ type: 'varchar', length: 32, default: 'pending' })
  verificationStatus: string; // pending, verified, rejected

  @Column({ type: 'varchar', length: 255, nullable: true })
  idHash: string | null;

  @Column({ type: 'timestamp', nullable: true })
  dateOfBirth: Date | null;

  // ── Profile & Preferences ──
  @Column({ type: 'varchar', length: 16, nullable: true })
  gender: string | null;

  @Column({ type: 'varchar', length: 16, default: 'any' })
  genderPreference: string; // male, female, any

  @Column({ type: 'varchar', length: 512, nullable: true })
  profilePictureUrl: string | null;

  @ManyToOne(() => Avatar, { nullable: true })
  @JoinColumn({ name: 'avatar_id' })
  avatar: Avatar | null;

  @Column({ type: 'int', nullable: true })
  avatar_id: number | null;

  @Column({ type: 'text', nullable: true })
  customizations: string | null; // JSON string for colors/accessories

  @Column({ type: 'text', nullable: true })
  interests: string | null;

  // ── Ratings & Moderation ──
  @Column({ type: 'float', default: 5.0 })
  rating: number;

  @Column({ type: 'int', default: 0 })
  warnings: number;

  @Column({ type: 'boolean', default: false })
  withdrawalBlocked: boolean;

  @Column({ type: 'varchar', length: 255, nullable: true })
  stripeAccountId: string | null;

  @CreateDateColumn()
  createdAt: Date;

  // ── Relationships ──
  @OneToOne(() => Wallet, (wallet) => wallet.user)
  wallet: Wallet;
}
