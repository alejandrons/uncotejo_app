import { v4 as uuidv4, validate } from 'uuid';
import Match from '../models/match.model';
import Team from '../models/team.model';
import { IMatch } from '../views/match';

export default class MatchService {
    /* CREAR */
    static async createMatch(data: IMatch): Promise<Match> {
        const link = `partido-${uuidv4()}`;

        return await Match.create({
            ...data,
            link,
            homeTeamAttendance: true,
            awayTeamAttendance: false,
        });
    }

    /* LEER */
    static async getAllMatches(): Promise<Match[]> {
        return await Match.findAll({
            include: [Team],
        });
    }

    static async getMatchById(matchId: number): Promise<Match | null> {
        return await Match.findByPk(matchId, {
            include: [Team],
        });
    }

    static async getMatchByLink(link: string): Promise<Match | null> {
        return await Match.findOne({
            where: { link },
            include: [Team],
        });
    }
    /* ACTUALIZAR */
    static async makeMatchById(
        matchId: number,
        awayTeamId: number,
        fixedTime: string,
    ): Promise<Match> {
        const match = await Match.findByPk(matchId);
        const awayTeam = await Team.findByPk(awayTeamId);

        validateMatch(match, awayTeam);

        validateMatch(match, awayTeam);
        match!.awayTeamId = awayTeamId;
        match!.fixedTime = fixedTime;
        await match!.save();
        return match!;
    }

    static async makeMatchByLink(
        link: string,
        awayTeamId: number,
        fixedTime: string,
    ): Promise<Match> {
        const match = await Match.findOne({ where: { link } });
        const awayTeam = await Team.findByPk(awayTeamId);

        validateMatch(match, awayTeam);

        match!.awayTeamId = awayTeamId;
        match!.fixedTime = fixedTime;
        await match!.save();
        return match!;
    }
}
function validateMatch(match: Match | null, awayTeam: Team | null) {
    if (!match) throw new Error('Partido no encontrado.');
    if (match.awayTeamId) throw new Error('El partido ya tiene un equipo visitante.');
    if (!awayTeam) throw new Error('El equipo visitante no existe.');
}
