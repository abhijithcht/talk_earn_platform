import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { User } from './user.entity';

@Entity('transactions')
export class Transaction {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'int' })
  userId: number;

  @Column({ type: 'int' })
  coins: number;

  @Column({ type: 'varchar', length: 32 })
  type: string; // earn, withdraw, bonus

  @Column({ type: 'varchar', length: 32, default: 'completed' })
  status: string; // pending, completed, failed

  @Column({ type: 'varchar', length: 64, nullable: true })
  payoutProvider: string | null; // Stripe, PayPal

  @CreateDateColumn()
  createdAt: Date;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'userId' })
  user: User;
}
