import { Request, Response, NextFunction } from 'express';
import { IAuthRequest } from '../middlewares/auth.middleware';
import { IMatch } from '../views/match';

export function validateCreateMatch(req: IAuthRequest, res: Response, next: NextFunction): void {
    const { possibleDates, fixedTime, homeTeamId } = req.body;

    if (!possibleDates || (typeof possibleDates !== 'object')) {
        res.status(400).json({ error: 'El campo possibleDates es obligatorio y debe tener un formato válido.' });
        return;
    }

    const hasDays = possibleDates.days && Array.isArray(possibleDates.days);
    const hasRange = possibleDates.range && possibleDates.range.from && possibleDates.range.to;

    if (hasDays && hasRange) {
        res.status(400).json({ error: 'Debe enviarse una lista de días O un rango de fechas, no ambos.' });
        return;
    }

    if (!hasDays && !hasRange) {
        res.status(400).json({ error: 'Debe incluir una lista de días o un rango de fechas en possibleDates.' });
        return;
    }

    const timeRegex = /^([0-1]\d|2[0-3]):([0-5]\d)$/;
    if (!fixedTime || !timeRegex.test(fixedTime)) {
        res.status(400).json({ error: 'El campo fixedTime es obligatorio y debe estar en formato HH:mm.' });
        return;
    }

    if (!homeTeamId || isNaN(parseInt(homeTeamId))) {
        res.status(400).json({ error: 'El homeTeamId es obligatorio y debe ser un número válido.' });
        return;
    }

    next();
}
