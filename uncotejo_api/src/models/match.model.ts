import { Table, Column, Model, DataType, ForeignKey, BelongsTo } from 'sequelize-typescript';
import Team from './team.model';

@Table({ tableName: 'matches', timestamps: true })
export default class Match extends Model {
    @Column({ type: DataType.JSON, allowNull: false })
    possibleDates!: { days?: string[]; range?: { from: string; to: string } };

    @Column({ type: DataType.TIME, allowNull: false })
    fixedTime!: string;

    @Column({ type: DataType.STRING, allowNull: false, unique: true })
    link!: string;

    @ForeignKey(() => Team)
    @Column({ type: DataType.INTEGER, allowNull: false })
    homeTeamId!: number;

    @BelongsTo(() => Team, 'homeTeamId')
    homeTeam!: Team;

    @ForeignKey(() => Team)
    @Column({ type: DataType.INTEGER, allowNull: true })
    awayTeamId!: number;

    @BelongsTo(() => Team, 'awayTeamId')
    awayTeam!: Team;

    @Column({ type: DataType.BOOLEAN, defaultValue: false })
    homeTeamAttendance!: boolean;

    @Column({ type: DataType.BOOLEAN, defaultValue: false })
    awayTeamAttendance!: boolean;
}
