import { Router, Request, Response } from 'express';
import TeamService from '../services/team.service';
import { IAuthRequest, authMiddleware } from '../middlewares/auth.middleware';
import { validateLeadership, validatePlayer, validateTeam } from '../middlewares/team.middleware';

const router = Router();

/* CREAR */
router.post(
    '/',
    authMiddleware,
    validateTeam,
    async (req: IAuthRequest, res: Response): Promise<void> => {
        try {
            const team = await TeamService.createTeam(req.body, req.user!.id);
            res.status(201).json(team);
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 400).json({
                error: err.message || 'Error al crear el equipo.',
            });
        }
    },
);

/* LEER */
router.get('/', authMiddleware, async (_req: IAuthRequest, res: Response): Promise<void> => {
    try {
        const teams = await TeamService.getTeams();
        res.json(teams);
    } catch (error: unknown) {
        const err = error as Error & { status?: number };
        res.status(err.status || 500).json({
            error: err.message || 'Error al obtener los equipos.',
        });
    }
});

router.get('/:id', authMiddleware, async (req: Request, res: Response): Promise<void> => {
    try {
        const teamId = parseInt(req.params.id);
        const team = await TeamService.getTeamById(teamId);
        res.json(team);
    } catch (error: unknown) {
        const err = error as Error & { status?: number };
        res.status(err.status || 500).json({ error: err.message || 'Error al buscar el equipo.' });
    }
});

router.get(
    '/link/:linkAccess',
    authMiddleware,
    async (req: Request, res: Response): Promise<void> => {
        try {
            const { linkAccess } = req.params;
            const team = await TeamService.getTeamByLink(linkAccess);
            res.json(team);
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 500).json({
                error: err.message || 'Error al buscar el equipo.',
            });
        }
    },
);

/* ACTUALIZAR */
router.put(
    '/:id',
    authMiddleware,
    validateLeadership,
    async (req: IAuthRequest, res: Response): Promise<void> => {
        try {
            const teamId = parseInt(req.params.id);
            const updatedTeam = await TeamService.updateTeam(teamId, req.body);
            res.json(updatedTeam);
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 403).json({
                error: err.message || 'Error al actualizar el equipo.',
            });
        }
    },
);

router.put(
    '/join/:linkAccess',
    authMiddleware,
    validatePlayer,
    async (req: IAuthRequest, res: Response): Promise<void> => {
        try {
            const { linkAccess } = req.params;
            const team = await TeamService.getTeamByLink(linkAccess);
            await TeamService.addPlayerToTeam(req.user!.id, team!.id!);
            res.json({ message: 'Te has unido al equipo', team });
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 500).json({
                error: err.message || 'Error al unirse al equipo.',
            });
        }
    },
);

router.put(
    '/:id/join',
    authMiddleware,
    validatePlayer,
    async (req: IAuthRequest, res: Response): Promise<void> => {
        try {
            await TeamService.addPlayerToTeam(req.user!.id, parseInt(req.params.id));
            res.json({ message: 'Te has unido al equipo' });
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 500).json({
                error: err.message || 'Error al unirse al equipo.',
            });
        }
    },
);

router.put(
    '/:id/transfer/:newLeaderId',
    authMiddleware,
    validateLeadership,
    async (req: IAuthRequest, res: Response): Promise<void> => {
        try {
            await TeamService.transferLeadership(
                parseInt(req.params.newLeaderId),
                parseInt(req.params.id),
            );
            res.json({ message: 'Liderazgo transferido correctamente' });
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 403).json({
                error: err.message || 'Error al transferir el liderazgo.',
            });
        }
    },
);

/* ELIMINAR */
router.delete(
    '/:id/remove/:playerId',
    authMiddleware,
    validateLeadership,
    async (req: IAuthRequest, res: Response): Promise<void> => {
        try {
            await TeamService.removePlayerFromTeam(
                req.user!.id,
                parseInt(req.params.playerId),
                parseInt(req.params.id),
            );
            res.json({ message: 'Jugador eliminado del equipo' });
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 403).json({
                error: err.message || 'Error al eliminar jugador.',
            });
        }
    },
);

router.delete(
    '/:id/leave',
    authMiddleware,
    async (req: IAuthRequest, res: Response): Promise<void> => {
        try {
            await TeamService.leaveTeam(req.user!.id, parseInt(req.params.id));
            res.json({ message: 'Has salido del equipo.' });
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 400).json({
                error: err.message || 'Error al salir del equipo.',
            });
        }
    },
);

export default router;
