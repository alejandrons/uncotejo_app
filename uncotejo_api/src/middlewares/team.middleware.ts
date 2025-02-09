import { Request, Response, NextFunction } from 'express';
import { IAuthRequest } from './auth.middleware';
import { Role, ShieldForm, ShieldInterior } from '../utils/enums';

export function validateTeam(req: Request, res: Response, next: NextFunction): void {
    const { name, description, slogan, colorPrimary, colorSecondary, shieldForm, shieldInterior } =
        req.body;

    if (
        !name ||
        !description ||
        !slogan ||
        !colorPrimary ||
        !colorSecondary ||
        !shieldForm ||
        !shieldInterior
    ) {
        res.status(400).json({ error: 'Todos los campos obligatorios deben estar completos.' });
        return;
    }

    const hexColorRegex = /^#([A-Fa-f0-9]{6})$/;
    if (!hexColorRegex.test(colorPrimary) || !hexColorRegex.test(colorSecondary)) {
        res.status(400).json({
            error: 'Los colores deben estar en formato hexadecimal (#RRGGBB).',
        });
        return;
    }

    if (!Object.values(ShieldForm).includes(shieldForm)) {
        res.status(400).json({
            error: `Valor inválido para shieldForm. Debe ser uno de: ${Object.values(ShieldForm).join(', ')}`,
        });
        return;
    }

    if (!Object.values(ShieldInterior).includes(shieldInterior)) {
        res.status(400).json({
            error: `Valor inválido para shieldInterior. Debe ser uno de: ${Object.values(ShieldInterior).join(', ')}`,
        });
        return;
    }

    next();
}

export const validateLeadership = async (req: IAuthRequest, res: Response, next: NextFunction) => {
    if (req.user!.role != Role.TeamLeader) {
        res.status(403).json({ error: 'Debes ser lider de equipo para realizar esta accion' });
        return;
    }
    next();
};

export const validatePlayer = async (req: IAuthRequest, res: Response, next: NextFunction) => {
    if (req.user!.role != Role.TeamLeader) {
        res.status(403).json({ error: 'Debes ser un jugador para realizar esta accion' });
        return;
    }
    next();
};
