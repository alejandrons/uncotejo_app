import { v4 as uuidv4 } from 'uuid';
import Match from '../models/match.model';
import Team from '../models/team.model';
import { IMatch } from '../views/match';
import { makeErrorResponse } from '../utils/errorHandler';

export default class MatchService {
    /* CREAR */
    static async createMatch(data: IMatch): Promise<Match> {
        this.validatePossibleDates(data.possibleDates);

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
            include: [
                {
                    model: Team,
                    as: 'homeTeam',
                    include: ['teamLeader'],
                },
                {
                    model: Team,
                    as: 'awayTeam',
                    include: ['teamLeader'],
                },
            ],
        });
    }

    static async getMatchById(matchId: number): Promise<Match> {
        const match = await Match.findByPk(matchId, {
            include: [
                {
                    model: Team,
                    as: 'homeTeam',
                    include: ['teamLeader'],
                },
                {
                    model: Team,
                    as: 'awayTeam',
                    include: ['teamLeader'],
                },
            ],
        });

        if (!match) throw makeErrorResponse(404, 'Partido no encontrado');
        return match;
    }

    static async getMatchByLink(link: string): Promise<Match> {
        const match = await Match.findOne({
            where: { link },
            include: [
                {
                    model: Team,
                    as: 'homeTeam',
                    include: ['teamLeader'],
                },
                {
                    model: Team,
                    as: 'awayTeam',
                    include: ['teamLeader'],
                },
            ],
        });

        if (!match) throw makeErrorResponse(404, 'Partido no encontrado');
        return match;
    }

    /* ACTUALIZAR */
    static async makeMatchById(
        matchId: number,
        awayTeamId: number,
        fixedTime: string,
    ): Promise<Match> {
        const match = await Match.findByPk(matchId);
        const awayTeam = await Team.findByPk(awayTeamId);

        this.validateMatch(match, awayTeam);

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

        this.validateMatch(match, awayTeam);

        match!.awayTeamId = awayTeamId;
        match!.fixedTime = fixedTime;
        await match!.save();
        return match!;
    }

    static validatePossibleDates(possibleDates: {
        days?: string[];
        range?: { from: string; to: string };
    }) {
        const hasDays = Array.isArray(possibleDates.days);
        const hasRange = possibleDates.range && possibleDates.range.from && possibleDates.range.to;

        if (hasDays && hasRange) {
            throw makeErrorResponse(
                400,
                'Debe enviarse una lista de días O un rango de fechas, no ambos.',
            );
        }

        if (!hasDays && !hasRange) {
            throw makeErrorResponse(
                400,
                'Debe incluir una lista de días o un rango de fechas en possibleDates.',
            );
        }
    }

    static validateMatch(match: Match | null, awayTeam: Team | null) {
        if (!match) throw makeErrorResponse(404, 'Partido no encontrado');
        if (match.awayTeamId)
            throw makeErrorResponse(409, 'El partido ya tiene un equipo visitante');
        if (!awayTeam) throw makeErrorResponse(404, 'El equipo visitante no existe');
    }
}
