import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { User } from './user.entity';

@Entity('sessions')
export class SessionRecord {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'int' })
  callerId: number;

  @Column({ type: 'int' })
  calleeId: number;

  @Column({ type: 'varchar', length: 16, default: 'text' })
  sessionType: string; // text, audio, video

  @Column({ type: 'int' })
  durationMinutes: number;

  @Column({ type: 'int', nullable: true })
  rating: number | null;

  @CreateDateColumn()
  createdAt: Date;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'callerId' })
  caller: User;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'calleeId' })
  callee: User;
}
