import { Router, Request, Response } from 'express';
import TeamService from '../services/team.service';
import { IAuthRequest, authMiddleware } from '../middlewares/auth.middleware';
import { validateTeam } from '../middlewares/team.middleware';
import { validateLeadership, validatePlayer } from '../middlewares/user.middleware';
import { handleErrorResponse, handleValidationErrors } from '../utils/errorHandler';

const router = Router();

/* CREAR */
router.post(
    '/',
    authMiddleware,
    validateTeam,
    handleValidationErrors,
    async (req: IAuthRequest, res: Response) => {
        try {
            const team = await TeamService.createTeam(req.body, req.user!.id);
            res.status(201).json(team);
        } catch (error) {
            handleErrorResponse(res, error);
        }
    },
);

/* LEER */
router.get('/', authMiddleware, async (_req: IAuthRequest, res: Response) => {
    try {
        const teams = await TeamService.getTeams();
        res.json(teams);
    } catch (error) {
        handleErrorResponse(res, error);
    }
});

router.get('/:id', authMiddleware, async (req: Request, res: Response) => {
    try {
        const teamId = parseInt(req.params.id);
        const team = await TeamService.getTeamById(teamId);

        res.json(team);
    } catch (error) {
        handleErrorResponse(res, error);
    }
});

router.get('/link/:linkAccess', authMiddleware, async (req: Request, res: Response) => {
    try {
        const { linkAccess } = req.params;
        const team = await TeamService.getTeamByLink(linkAccess);

        res.json(team);
    } catch (error) {
        handleErrorResponse(res, error);
    }
});

/* ACTUALIZAR */
router.put(
    '/:id',
    authMiddleware,
    validateLeadership,
    handleValidationErrors,
    async (req: IAuthRequest, res: Response) => {
        try {
            const teamId = parseInt(req.params.id);
            const updatedTeam = await TeamService.updateTeam(teamId, req.body);
            res.json(updatedTeam);
        } catch (error) {
            handleErrorResponse(res, error);
        }
    },
);

router.put(
    '/join/:linkAccess',
    authMiddleware,
    validatePlayer,
    handleValidationErrors,
    async (req: IAuthRequest, res: Response) => {
        try {
            const { linkAccess } = req.params;
            const team = await TeamService.getTeamByLink(linkAccess);

            await TeamService.addPlayerToTeam(req.user!.id, team!.id!);
            res.json({ message: 'Te has unido al equipo', team });
        } catch (error) {
            handleErrorResponse(res, error);
        }
    },
);

/* ELIMINAR */
router.delete(
    '/:id/remove/:playerId',
    authMiddleware,
    validateLeadership,
    async (req: IAuthRequest, res: Response) => {
        try {
            await TeamService.removePlayerFromTeam(
                req.user!.id,
                parseInt(req.params.playerId),
                parseInt(req.params.id),
            );
            res.json({ message: 'Jugador eliminado del equipo' });
        } catch (error) {
            handleErrorResponse(res, error);
        }
    },
);

router.delete('/:id/leave', authMiddleware, async (req: IAuthRequest, res: Response) => {
    try {
        await TeamService.leaveTeam(req.user!.id, parseInt(req.params.id));
        res.json({ message: 'Has salido del equipo.' });
    } catch (error) {
        handleErrorResponse(res, error);
    }
});

export default router;
