import { Router, Request, Response } from 'express';
import MatchService from '../services/match.service';
import { IAuthRequest, authMiddleware } from '../middlewares/auth.middleware';
import { IMatch } from '../views/match';
import { validateLeadership } from '../middlewares/team.middleware';
import { validateCreateMatch } from '../middlewares/match.middleware';

const router = Router();

/* CREAR */
router.post(
    '/',
    authMiddleware,
    validateLeadership,
    validateCreateMatch,
    async (req: IAuthRequest, res: Response): Promise<void> => {
        try {
            const match: IMatch = await MatchService.createMatch(req.body);
            res.status(201).json(match);
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 400).json({
                error: err.message || 'Error al crear el partido.',
            });
        }
    },
);

/* LEER */
router.get('/', authMiddleware, async (_req: Request, res: Response): Promise<void> => {
    try {
        const matches: IMatch[] = await MatchService.getAllMatches();
        res.json(matches);
    } catch (error: unknown) {
        const err = error as Error & { status?: number };
        res.status(err.status || 500).json({ error: err.message || 'Error al obtener partidos.' });
    }
});

router.get('/:id', authMiddleware, async (req: Request, res: Response): Promise<void> => {
    try {
        const matchId = parseInt(req.params.id);
        const match: IMatch | null = await MatchService.getMatchById(matchId);
        if (!match) {
            res.status(404).json({ error: 'Partido no encontrado.' });
            return;
        }
        res.json(match);
    } catch (error: unknown) {
        const err = error as Error & { status?: number };
        res.status(err.status || 500).json({
            error: err.message || 'Error al obtener el partido.',
        });
    }
});

router.get('/link/:link', authMiddleware, async (req: Request, res: Response): Promise<void> => {
    try {
        const { link } = req.params;
        const match: IMatch | null = await MatchService.getMatchByLink(link);
        if (!match) {
            res.status(404).json({ error: 'Partido no encontrado.' });
            return;
        }
        res.json(match);
    } catch (error: unknown) {
        const err = error as Error & { status?: number };
        res.status(err.status || 500).json({ error: err.message || 'Error al buscar el partido.' });
    }
});

/* ACTUALIZAR */
router.put(
    '/:id/match',
    authMiddleware,
    validateLeadership,
    async (req: IAuthRequest, res: Response): Promise<void> => {
        try {
            const matchId = parseInt(req.params.id);
            const { awayTeamId, fixedTime } = req.body;
            const match = await MatchService.makeMatchById(matchId, awayTeamId, fixedTime);
            res.json(match);
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 400).json({
                error: err.message || 'Error al pactar el partido.',
            });
        }
    },
);

router.put(
    '/link/:link/match',
    authMiddleware,
    validateLeadership,
    async (req: IAuthRequest, res: Response): Promise<void> => {
        try {
            const { link } = req.params;
            const { awayTeamId, fixedTime } = req.body;
            const match = await MatchService.makeMatchByLink(link, awayTeamId, fixedTime);
            res.json(match);
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 400).json({
                error: err.message || 'Error al pactar el partido.',
            });
        }
    },
);

export default router;
