export interface IMatch {
    id?: number;
    possibleDates: { days?: string[]; range?: { from: string; to: string } };
    fixedTime: string;
    link?: string;
    homeTeamId: number;
    awayTeamId: number;
    homeTeamAttendance?: boolean;
    awayTeamAttendance?: boolean;
}
