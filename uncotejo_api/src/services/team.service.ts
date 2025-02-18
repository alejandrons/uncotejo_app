import { v4 as uuidv4 } from 'uuid';
import Team from '../models/team.model';
import { ITeam } from '../views/team';
import { Role } from '../utils/enums';
import User from '../models/user.model';
import { makeErrorResponse } from '../utils/errorHandler';

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

        await user.save({ fields: ['role'] });

        return newTeam;
    }

    static async getTeams(): Promise<ITeam[]> {
        return await Team.findAll();
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
        const team = await Team.findByPk(teamId, {
            include: [
                { model: User, as: 'teamLeader' },
                { model: User, as: 'players' },
            ],
        });
        if (!team) throw makeErrorResponse(404, 'Equipo');

        const existingPlayer = await team.$has('players', playerId);
        if (existingPlayer) {
            console.log('aqui');
            throw makeErrorResponse(409, 'El usuario ya es parte de este equipo.');
        }

        if (!(await team.canAddPlayer())) {
            throw makeErrorResponse(409, 'El equipo ha alcanzado el número máximo de jugadores.');
        }

        await team.$add('players', playerId);
    }

    static async transferLeadership(newLeaderId: number, teamId: number): Promise<void> {
        const team = await Team.findByPk(teamId);
        if (!team) {
            throw makeErrorResponse(404, 'Equipo');
        }

        const oldLeader = await User.findByPk(team.teamLeaderId);
        if (!oldLeader) {
            throw makeErrorResponse(404, 'Líder actual');
        }

        const newLeader = await User.findByPk(newLeaderId);
        if (!newLeader) {
            throw makeErrorResponse(404, 'Usuario');
        }

        if (newLeader.role !== Role.Player) {
            throw makeErrorResponse(409, 'Solo un jugador puede convertirse en líder.');
        }

        oldLeader.role = Role.Player;
        newLeader.role = Role.TeamLeader;

        await oldLeader.save();
        await newLeader.save();

        team.teamLeaderId = newLeaderId;
        await team.save();
    }

    static async removePlayerFromTeam(
        leaderId: number,
        playerId: number,
        teamId: number,
    ): Promise<void> {
        const team = await Team.findByPk(teamId);
        if (!team) {
            throw makeErrorResponse(404, 'Equipo');
        }

        if (playerId === leaderId) {
            throw makeErrorResponse(409, 'El líder del equipo no puede eliminarse a sí mismo.');
        }

        await team.$remove('players', playerId);
    }

    static async leaveTeam(userId: number, teamId: number): Promise<void> {
        const team = await Team.findByPk(teamId, { include: [User] });
        if (!team) throw makeErrorResponse(404, 'Equipo');

        const playerCount = await team.$count('players');

        if (userId === team.teamLeaderId) {
            throw makeErrorResponse(
                409,
                'El líder del equipo no puede abandonarlo si hay jugadores.',
            );
        }

        if (playerCount === 0) {
            await team.destroy();
            return;
        }

        await team.$remove('players', userId);
    }
}
