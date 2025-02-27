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
    AlianzaPetrolera = 'Alianza-Petrolera.png',
    America = 'America-de-Cali.png',
    AtleticoNacional = 'Atletico-Nacional.png',
    BoyacaChico = 'Boyaca-Chico.png',
    Bucaramanga = 'Bucaramanga.png',
    DeportivoCali = 'Deportivo-Cali.png',
    Envigado = 'Envigado.png',
    Huila = 'Huila.png',
    Junior = 'Junior.png',
    Medellin = 'Medellin.png',
    Millonarios = 'Millonarios.png',
    OnceCaldas = 'Once-Caldas.png',
    Pasto = 'Pasto.png',
    Pereira = 'Pereira.png',
    Quindio = 'Quindio.png',
    Rionegroaguilas = 'Rionegro-Aguilas.png',
    SantaFe = 'Santa-Fe.png',
    Tolima = 'Tolima.png',
    UnionMagdalena = 'Union-Magdalena.png',
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
