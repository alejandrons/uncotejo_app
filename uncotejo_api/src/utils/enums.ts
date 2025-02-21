export enum Gender {
    Masculino = 'Masculino',
    Femenino = 'Femenino',
    Otro = 'Otro',
}

export enum Position {
    Delantero = 'Delantero',
    Defensa = 'Defensa',
    Portero = 'Portero',
    Centrocampista = 'Centrocampista',
}

export enum Role {
    Admin = 'admin',
    Player = 'player',
    TeamLeader = 'team_leader',
}

export enum ShieldForm {
    Maedellin = 'medellin.png',
    Nacional = 'nacional.png',
    Triangle = 'triangle',
    Star = 'star',
    Hexagon = 'hexagon',
    Shield1 = 'shield1',
    Shield2 = 'shield2',
    Shield3 = 'shield3',
    Shield4 = 'shield4',
    Shield5 = 'shield5',

}

export enum ShieldInterior {
    Pattern1 = 'pattern1',
    Pattern2 = 'pattern2',
    Pattern3 = 'pattern3',
    Pattern4 = 'pattern4',
    Pattern5 = 'pattern5',
    Pattern6 = 'pattern6',
    Pattern7 = 'pattern7',
    Pattern8 = 'pattern8',
    Pattern9 = 'pattern9',
    Pattern10 = 'pattern10',
}

export enum TeamType {
    Futsal = 'futsal',
    Football = 'football',
}

export const MAX_PLAYERS: Record<TeamType, number> = {
    [TeamType.Futsal]: 10,
    [TeamType.Football]: 22,
};
