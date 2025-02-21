import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { Role } from '../utils/enums';

const JWT_SECRET = process.env.JWT_SECRET || 'secreto_super_seguro';

export interface IAuthRequest extends Request {
    user?: { id: number; role: Role };
}

export function authMiddleware(req: IAuthRequest, res: Response, next: NextFunction): void {
    const token = req.header('Authorization')?.split(' ')[1];

    if (!token) {
        res.status(401).json({ error: 'Acceso denegado. Token no proporcionado.' });
        return;
    }

    try {
        const decoded = jwt.verify(token, JWT_SECRET) as IAuthRequest['user'];
        req.user = decoded;

        next();
    } catch (error) {
        res.status(401).json({ error: 'Token inválido o expirado.' });
    }
}

