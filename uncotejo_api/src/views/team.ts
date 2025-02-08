import { ShieldForm, ShieldInterior } from '../utils/enums';
import { IUser } from './user';

export interface ITeam {
    id?: number;
    name: string;
    description: string;
    slogan: string;
    linkAccess: string;
    colorPrimary: string;
    colorSecondary: string;
    shieldForm: ShieldForm;
    shieldInterior: ShieldInterior;
    teamLeaderId: number;
    players?: IUser[];
}
