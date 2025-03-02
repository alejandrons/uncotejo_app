import {
    Table,
    Column,
    Model,
    DataType,
    BeforeCreate,
    BeforeUpdate,
    Unique,
    BelongsTo,
    ForeignKey,
} from 'sequelize-typescript';
import bcrypt from 'bcryptjs';
import { IUser } from '../views/user';
import { Gender, Position, Role } from '../utils/enums';
import Team from './team.model';

@Table({
    tableName: 'users',
    timestamps: true,
})
export default class User extends Model<IUser> {
    @Column({
        type: DataType.STRING,
        allowNull: false,
    })
    name!: string;

    @Column({
        type: DataType.ENUM(...Object.values(Gender)),
        allowNull: true,
    })
    gender?: Gender;

    @Column({
        type: DataType.ENUM(...Object.values(Position)),
        allowNull: true,
    })
    position?: Position;

    @Column({
        type: DataType.ENUM(...Object.values(Role)),
        allowNull: false,
        defaultValue: Role.Player,
    })
    role!: Role;

    @Unique
    @Column({
        type: DataType.STRING,
        allowNull: false,
        unique: true,
        validate: {
            isEmail: true,
        },
    })
    email!: string;

    @Column({
        type: DataType.STRING,
        allowNull: false,
    })
    password!: string;

    @ForeignKey(() => Team)
    @Column({ type: DataType.INTEGER, allowNull: true })
    teamId!: number | null;

    @BelongsTo(() => Team)
    team!: Team;

    @BeforeCreate
    @BeforeUpdate
    static hashPassword(instance: User) {
        if (instance.changed('password')) {
            instance.password = bcrypt.hashSync(instance.password, 10);
        }
    }

    checkPassword(password: string): boolean {
        return bcrypt.compareSync(password, this.password);
    }
}
