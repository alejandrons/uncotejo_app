import {
    Table,
    Column,
    Model,
    DataType,
    ForeignKey,
    BelongsTo,
    HasMany,
} from 'sequelize-typescript';
import { ITeam } from '../views/team';
import User from './user.model';
import { MAX_PLAYERS, ShieldForm, ShieldInterior, TeamType } from '../utils/enums';

@Table({
    tableName: 'teams',
    timestamps: true,
})
export default class Team extends Model<ITeam> {
    @Column({
        type: DataType.STRING,
        allowNull: false,
        unique: true,
    })
    name!: string;

    @Column({
        type: DataType.TEXT,
        allowNull: false,
    })
    description!: string;

    @Column({
        type: DataType.STRING,
        allowNull: false,
    })
    slogan!: string;

    @Column({
        type: DataType.STRING,
        allowNull: false,
        unique: true,
    })
    linkAccess!: string;

    @Column({
        type: DataType.STRING,
        allowNull: true,
    })
    colorPrimary!: string;

    @Column({
        type: DataType.STRING,
        allowNull: true,
    })
    colorSecondary!: string;

    @Column({
        type: DataType.ENUM(...Object.values(ShieldForm)),
        allowNull: false,
    })
    shieldForm!: ShieldForm;

    @Column({
        type: DataType.ENUM(...Object.values(ShieldInterior)),
        allowNull: true,
    })
    shieldInterior!: ShieldInterior;

    @Column({
        type: DataType.ENUM(...Object.values(TeamType)),
        allowNull: false,
    })
    teamType!: TeamType;

    @ForeignKey(() => User)
    @Column
    teamLeaderId!: number;

    @BelongsTo(() => User, { as: 'teamLeader' })
    teamLeader!: User;

    @HasMany(() => User, { as: 'players' })
    players!: User[];

    async canAddPlayer(): Promise<boolean> {
        const currentPlayers = await this.$count('players');
        return currentPlayers < MAX_PLAYERS[this.teamType];
    }
}
