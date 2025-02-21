import { Gender, Position, Role } from '../utils/enums';

export interface IUser {
    id?: number;
    firstName: string;
    lastName: string;
    gender?: Gender;
    position?: Position;
    role: Role;
    teamId?: number | null;
    email: string;
    password: string;
}
