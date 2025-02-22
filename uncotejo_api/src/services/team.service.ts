import { v4 as uuidv4 } from 'uuid';
import Team from '../models/team.model';
import { ITeam } from '../views/team';
import { MAX_PLAYERS, Role } from '../utils/enums';
import User from '../models/user.model';
import { makeErrorResponse } from '../utils/errorHandler';
import Match from '../models/match.model';
import { Op } from 'sequelize';
import sequelize from '../config/db';

export default class TeamService {
    static async createTeam(data: ITeam, requesterId: number): Promise<ITeam> {
        const existingTeam = await Team.findOne({ where: { name: data.name } });
        if (existingTeam) {
            throw makeErrorResponse(409, 'El nombre del equipo ya está en uso.');
        }

        let user = await User.findByPk(requesterId);
        if (!user) {
            throw makeErrorResponse(404, 'Usuario no encontrado.');
        }

        const isAlreadyLeader = await Team.findOne({ where: { teamLeaderId: requesterId } });
        if (isAlreadyLeader) {
            throw makeErrorResponse(
                409,
                'Ya eres líder de otro equipo. No puedes liderar más de un equipo.',
            );
        }

        const linkAccess = `equipo-${uuidv4()}`;
        const newTeam = await Team.create({
            ...data,
            linkAccess,
            teamLeaderId: requesterId,
        });

        // Recargar usuario para asegurarnos de que los datos están actualizados
        user = await User.findByPk(requesterId);
        if (!user) {
            throw makeErrorResponse(404, 'Usuario no encontrado después de crear el equipo.');
        }

        user.role = Role.TeamLeader;
        user.teamId = newTeam.id;
        await user.save({ fields: ['role', 'teamId'] });

        return newTeam;
    }

    static async getTeams(): Promise<ITeam[]> {
        const teams = await Team.findAll({ include: [{ model: User, as: 'players' }] });

        return teams.filter((team) => team.players.length < MAX_PLAYERS[team.teamType]);
    }

    static async getTeamById(teamId: number): Promise<ITeam | null> {
        const team = await Team.findByPk(teamId, {
            include: [
                { model: User, as: 'teamLeader' },
                { model: User, as: 'players' },
            ],
        });
        if (!team) throw makeErrorResponse(404, 'Equipo');
        return team;
    }

    static async getTeamByLink(linkAccess: string): Promise<ITeam | null> {
        const team = await Team.findOne({
            where: { linkAccess },
            include: [
                { model: User, as: 'teamLeader' },
                { model: User, as: 'players' },
            ],
        });
        if (!team) throw makeErrorResponse(404, 'Equipo');
        return team;
    }

    static async updateTeam(teamId: number, data: Partial<ITeam>): Promise<ITeam> {
        const team = await Team.findByPk(teamId);
        if (!team) throw makeErrorResponse(404, 'Equipo');

        if (data.name && data.name !== team.name) {
            const existingTeam = await Team.findOne({ where: { name: data.name } });
            if (existingTeam && existingTeam.id !== teamId) {
                throw makeErrorResponse(409, 'El nombre del equipo ya está en uso.');
            }
        }

        await team.update(data);
        return team;
    }

    static async addPlayerToTeam(playerId: number, teamId: number): Promise<void> {
        let user = await User.findByPk(playerId);
        if (!user) {
            throw makeErrorResponse(404, 'usuario');
        }

        const team = await Team.findByPk(teamId, {
            include: [
                { model: User, as: 'teamLeader' },
                { model: User, as: 'players' },
            ],
        });
        if (!team) throw makeErrorResponse(404, 'Equipo');

        const existingPlayer = await team.$has('players', playerId);
        if (existingPlayer) {
            throw makeErrorResponse(409, 'El usuario ya es parte de este equipo.');
        }

        if (!(await team.canAddPlayer())) {
            throw makeErrorResponse(409, 'El equipo ha alcanzado el número máximo de jugadores.');
        }
        user.teamId = team.id;
        await user.save({ fields: ['teamId'] });
        await team.$add('players', playerId);
    }

    static async transferLeadership(newLeaderId: number, teamLeaderId: number): Promise<void> {
        const transaction = await sequelize.transaction();
        try {
            const oldLeader = await User.findByPk(teamLeaderId, { transaction });
            if (!oldLeader) {
                throw makeErrorResponse(404, 'Líder actual');
            }
            if (newLeaderId === teamLeaderId) {
                throw makeErrorResponse(400, 'El usuario no puede transferirse a sí mismo.');
            }

            const newLeader = await User.findByPk(newLeaderId, { transaction });
            if (!newLeader) {
                throw makeErrorResponse(404, 'Usuario');
            }

            if (oldLeader.teamId === null) {
                throw makeErrorResponse(404, 'Equipo no encontrado.');
            }
            const team = await Team.findByPk(oldLeader.teamId, { transaction });
            if (!team) {
                throw makeErrorResponse(404, 'Equipo');
            }

            const players = await team.$get('players', { transaction });
            if (!players.some((player) => player.id === newLeader.id)) {
                throw makeErrorResponse(400, 'El nuevo líder debe ser un jugador del equipo.');
            }

            await oldLeader.update(
                { role: Role.Player },
                { where: { id: oldLeader.id }, transaction },
            );
            await newLeader.update(
                { role: Role.TeamLeader },
                { where: { id: newLeader.id }, transaction },
            );
            await team.update(
                { teamLeaderId: newLeaderId },
                { where: { id: team.id }, transaction },
            );

            await transaction.commit();
        } catch (error) {
            await transaction.rollback();
            throw error;
        }
    }

    static async removePlayerFromTeam(playerId: number): Promise<void> {
        let user = await User.findByPk(playerId);
        if (!user) {
            throw makeErrorResponse(404, 'usuario');
        }

        if (user.teamId === null) {
            throw makeErrorResponse(404, 'Equipo no encontrado.');
        }
        const team = await Team.findByPk(user.teamId);
        if (!team) {
            throw makeErrorResponse(404, 'Equipo');
        }

        if (playerId === team.teamLeaderId) {
            throw makeErrorResponse(409, 'El líder del equipo no puede eliminarse a sí mismo.');
        }

        user.teamId = null;
        await user.save({ fields: ['teamId'] });
        await team.$remove('players', playerId);
    }

    static async findMatchesByTeam(teamId: number): Promise<Match[]> {
        return await Match.findAll({
            where: {
                [Op.or]: [{ homeTeamId: teamId }, { awayTeamId: teamId }],
            },
            include: [
                { model: Team, as: 'homeTeam' },
                { model: Team, as: 'awayTeam' },
            ],
        });
    }

    static async leaveTeam(userId: number): Promise<void> {
        let user = await User.findByPk(userId);
        if (!user) {
            throw makeErrorResponse(404, 'usuario');
        }

        if (user.teamId === null) {
            throw makeErrorResponse(404, 'Equipo no encontrado.');
        }
        const team = await Team.findByPk(user.teamId, {
            include: [
                { model: User, as: 'teamLeader' },
                { model: User, as: 'players' },
            ],
        });
        if (!team) throw makeErrorResponse(404, 'Equipo');

        const playerCount = await team.$count('players');
        if (playerCount === 0) {
            const ongoingMatches = await TeamService.findMatchesByTeam(team.id);
            if (ongoingMatches.length > 0) {
                throw makeErrorResponse(
                    409,
                    'El líder del equipo no puede abandonarlo hasta finalizar todos los partidos.',
                );
            }

            user.role = Role.Player;
            user.teamId = null;
            await user.save({ fields: ['role', 'teamId'] });
            await team.destroy();
            return;
        }

        if (userId === team.teamLeaderId) {
            throw makeErrorResponse(
                409,
                'El líder del equipo no puede abandonarlo si hay jugadores.',
            );
        }

        const isPlayerInTeam = team.players.some((player) => player.id === userId);

        if (!isPlayerInTeam) {
            throw makeErrorResponse(400, 'El usuario no pertenece a este equipo.');
        }
        user.teamId = null;
        await user.save({ fields: ['teamId'] });
        await team.$remove('players', userId);
    }
}
