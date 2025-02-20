import { Router, Request, Response } from 'express';
import MatchService from '../services/match.service';
import { IAuthRequest, authMiddleware } from '../middlewares/auth.middleware';
import { IMatch } from '../views/match';
import { validateCreateMatch } from '../middlewares/match.middleware';
import { validateLeadership } from '../middlewares/user.middleware';
import { handleErrorResponse, handleValidationErrors } from '../utils/errorHandler';

const router = Router();

/* CREAR */
router.post(
    '/',
    authMiddleware,
    validateLeadership,
    validateCreateMatch,
    handleValidationErrors,
    async (req: IAuthRequest, res: Response) => {
        try {
            const match: IMatch = await MatchService.createMatch(req.body);
            res.status(201).json(match);
        } catch (error) {
            handleErrorResponse(res, error);
        }
    },
);

/* LEER */
router.get('/', authMiddleware, async (_req: Request, res: Response) => {
    try {
        const matches: IMatch[] = await MatchService.getAllMatches();
        res.status(200).json(matches);
    } catch (error) {
        handleErrorResponse(res, error);
    }
});

router.get('/:id', authMiddleware, async (req: Request, res: Response) => {
    try {
        const matchId = parseInt(req.params.id);
        const match: IMatch | null = await MatchService.getMatchById(matchId);

        res.status(200).json(match);
    } catch (error) {
        handleErrorResponse(res, error);
    }
});

router.get('/link/:link', authMiddleware, async (req: Request, res: Response) => {
    try {
        const { link } = req.params;
        const match: IMatch | null = await MatchService.getMatchByLink(link);

        res.status(200).json(match);
    } catch (error) {
        handleErrorResponse(res, error);
    }
});

/* ACTUALIZAR */
router.put(
    '/:id/match',
    authMiddleware,
    validateLeadership,
    handleValidationErrors,
    async (req: IAuthRequest, res: Response) => {
        try {
            const matchId = parseInt(req.params.id);
            const { awayTeamId, fixedTime } = req.body;
            const match = await MatchService.makeMatchById(matchId, awayTeamId, fixedTime);
            res.status(200).json(match);
        } catch (error) {
            handleErrorResponse(res, error);
        }
    },
);

router.put(
    '/link/:link/match',
    authMiddleware,
    validateLeadership,
    handleValidationErrors,
    async (req: IAuthRequest, res: Response) => {
        try {
            const { link } = req.params;
            const { awayTeamId, fixedTime } = req.body;
            const match = await MatchService.makeMatchByLink(link, awayTeamId, fixedTime);
            res.status(200).json(match);
        } catch (error) {
            handleErrorResponse(res, error);
        }
    },
);

export default router;
