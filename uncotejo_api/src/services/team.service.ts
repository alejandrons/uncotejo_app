import { v4 as uuidv4 } from 'uuid';
import Team from '../models/team.model';
import { ITeam } from '../views/team';
import { Role } from '../utils/enums';
import User from '../models/user.model';

export default class TeamService {
    static async createTeam(data: ITeam, requesterId: number): Promise<ITeam> {
        const linkAccess = `equipo-${uuidv4()}`;

        const user = await User.findByPk(requesterId);
        if (!user) {
            throw new Error('Usuario no encontrado.');
        }
        const newTeam = await Team.create({
            ...data,
            linkAccess,
            teamLeaderId: requesterId,
        });

        user.role = Role.TeamLeader;
        await user.save();

        return newTeam;
    }

    static async getTeams(): Promise<ITeam[]> {
        return await Team.findAll();
    }

    static async getTeamById(teamId: number): Promise<ITeam | null> {
        const team = await Team.findByPk(teamId, { include: [User] });
        if (!team) throw new Error('Equipo no encontrado.');
        return team;
    }

    static async getTeamByLink(linkAccess: string): Promise<ITeam | null> {
        const team = await Team.findOne({ where: { linkAccess }, include: [User] });
        if (!team) throw new Error('Equipo no encontrado.');
        return team;
    }

    static async updateTeam(teamId: number, data: Partial<ITeam>): Promise<ITeam> {
        const team = await Team.findByPk(teamId);
        if (!team) throw new Error('Equipo no encontrado.');

        await team.update(data);
        return team;
    }

    static async addPlayerToTeam(playerId: number, teamId: number): Promise<void> {
        const team = await Team.findByPk(teamId, { include: [User] });
        if (!team) throw new Error('Equipo no encontrado.');

        if (!(await team.canAddPlayer())) {
            throw new Error('El equipo ha alcanzado el número máximo de jugadores.');
        }

        await team.$add('players', playerId);
    }

    static async transferLeadership(newLeaderId: number, teamId: number): Promise<void> {
        const team = await Team.findByPk(teamId);
        if (!team) {
            throw new Error('Equipo no encontrado.');
        }

        const oldLeader = await User.findByPk(team.teamLeaderId);
        if (!oldLeader) {
            throw new Error('Líder actual no encontrado.');
        }

        const newLeader = await User.findByPk(newLeaderId);
        if (!newLeader) {
            throw new Error('Usuario no encontrado.');
        }

        if (newLeader.role !== Role.Player) {
            throw new Error('Solo un jugador puede convertirse en líder.');
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
            throw new Error('Equipo no encontrado.');
        }

        if (playerId === leaderId) {
            throw new Error('El líder del equipo no puede eliminarse a sí mismo.');
        }

        await team.$remove('players', playerId);
    }

    static async leaveTeam(userId: number, teamId: number): Promise<void> {
        const team = await Team.findByPk(teamId, { include: [User] });
        if (!team) throw new Error('Equipo no encontrado.');

        const playerCount = await team.$count('players');

        if (userId === team.teamLeaderId) {
            throw new Error('El líder del equipo no puede abandonarlo si hay jugadores.');
        }

        if (playerCount === 0) {
            await team.destroy();
            return;
        }

        await team.$remove('players', userId);
    }
}
