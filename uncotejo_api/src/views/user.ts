import { Gender, Position, Role } from '../utils/enums';

export interface IUser {
    id?: number;
    name: string;
    gender?: Gender;
    position?: Position;
    role: Role;
    teamId?: number | null;
    email: string;
}
