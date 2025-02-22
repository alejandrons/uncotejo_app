import { v4 as uuidv4 } from 'uuid';
import Match from '../models/match.model';
import Team from '../models/team.model';
import { IMatch } from '../views/match';
import { makeErrorResponse } from '../utils/errorHandler';
import User from '../models/user.model';
import { Op } from 'sequelize';

export default class MatchService {
    /* CREAR */
    static async createMatch(data: IMatch, userId: number): Promise<Match> {
        let user = await User.findByPk(userId);
        if (!user) {
            throw makeErrorResponse(404, 'Usuario');
        }
        if (!user.teamId) {
            throw makeErrorResponse(400, 'El usuario no pertenece a ningún equipo');
        }

        let team = await Team.findOne({ where: { teamLeaderId: user.id } });
        if (!team) {
            throw makeErrorResponse(404, 'Equipo');
        }

        this.validatePossibleDates(data.possibleDates);

        const link = `partido-${uuidv4()}`;
        return await Match.create({
            ...data,
            link,
            homeTeamId: team.id,
            homeTeamAttendance: true,
            awayTeamAttendance: false,
        });
    }

    /* LEER */
    static async getAvailableMatches(userId: number): Promise<Match[]> {
        const user = await User.findByPk(userId);

        return await Match.findAll({
            where: {
                awayTeamId: null,
                ...(user?.teamId ? { homeTeamId: { [Op.ne]: user.teamId } } : {}),
            },
            include: [
                {
                    model: Team,
                    as: 'homeTeam',
                    include: [{ model: User, as: 'teamLeader' }],
                },
                {
                    model: Team,
                    as: 'awayTeam',
                    include: [{ model: User, as: 'teamLeader' }],
                },
            ],
        });
    }

    static async getMatchesForUserTeam(userId: number): Promise<Match[]> {
        const user = await User.findByPk(userId);
        if (!user || !user.teamId) {
            throw makeErrorResponse(400, 'El usuario no pertenece a ningún equipo');
        }

        return await Match.findAll({
            where: {
                [Op.or]: [{ homeTeamId: user.teamId }, { awayTeamId: user.teamId }],
            },
            include: [
                {
                    model: Team,
                    as: 'homeTeam',
                    include: [{ model: User, as: 'teamLeader' }],
                },
                {
                    model: Team,
                    as: 'awayTeam',
                    include: [{ model: User, as: 'teamLeader' }],
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
        userId: number,
        possibleDates: any,
        fixedTime: string,
    ): Promise<Match> {
        let user = await User.findByPk(userId);
        if (!user) {
            throw makeErrorResponse(404, 'Usuario');
        }
        if (!user.teamId) {
            throw makeErrorResponse(400, 'El usuario no pertenece a ningún equipo');
        }

        let awayTeam = await Team.findOne({ where: { teamLeaderId: user.id } });
        const match = await Match.findByPk(matchId);
        const homeTeam = await Team.findByPk(match!.homeTeamId);

        this.validateMatch(match, awayTeam);

        if (!homeTeam) {
            throw makeErrorResponse(404, 'El equipo local no existe');
        }

        if (homeTeam.teamType != awayTeam!.teamType) {
            throw makeErrorResponse(409, 'El tipo de equipo debe de ser el mismo');
        }

        if (awayTeam!.id === match!.homeTeamId) {
            throw makeErrorResponse(409, 'El equipo visitante no puede ser el mismo que el local');
        }

        match!.awayTeamId = awayTeam!.id;
        match!.possibleDates = possibleDates;
        match!.fixedTime = fixedTime;
        await match!.save();
        return match!;
    }

    static async makeMatchByLink(
        link: string,
        userId: number,
        possibleDates: any,
        fixedTime: string,
    ): Promise<Match> {
        const match = await Match.findOne({ where: { link } });
        if (!match) {
            throw makeErrorResponse(404, 'Partido no encontrado');
        }

        return await MatchService.makeMatchById(match.id, userId, possibleDates, fixedTime);
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
