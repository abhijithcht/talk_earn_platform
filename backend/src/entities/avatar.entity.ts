import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('avatars')
export class Avatar {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 512 })
  imageUrl: string;

  @Column({ type: 'varchar', length: 64, nullable: true })
  category: string | null; // neutral, gender-specific, cultural, fun
}
