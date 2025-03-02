import { body } from 'express-validator';
import { IAuthRequest } from './auth.middleware';
import { Role } from '../utils/enums';
import { Response, NextFunction } from 'express';

// Middleware para validar el registro de usuario
export const validateRegister = [
    body('name').isString().notEmpty().withMessage('El apellido es obligatorio.'),
    body('email').isEmail().withMessage('Formato de email inválido.'),
    body('password')
        .isLength({ min: 6 })
        .withMessage('La contraseña debe tener al menos 6 caracteres.'),
];

// Middleware para validar el inicio de sesión
export const validateLogin = [
    body('email').isEmail().withMessage('Formato de email inválido.'),
    body('password').notEmpty().withMessage('La contraseña es obligatoria.'),
];

// Middleware para validar la actualización de usuario
export const validateUpdateUser = [
    body().custom((value) => {
        if (!value || Object.keys(value).length === 0) {
            throw new Error('Debe enviar al menos un campo para actualizar.');
        }
    }),
    body('email').optional().isEmail().withMessage('Formato de email inválido.'),
];

// Middleware para verificar si el usuario es líder de equipo
export const validateLeadership = (req: IAuthRequest, res: Response, next: NextFunction) => {
    if (req.user?.role !== Role.TeamLeader) {
        res.status(403).json({ error: 'Debes ser líder de equipo para realizar esta acción.' });
        return;
    }
    next();
};

// Middleware para verificar si el usuario es un jugador
export const validatePlayer = (req: IAuthRequest, res: Response, next: NextFunction) => {
    if (req.user?.role !== Role.Player) {
        res.status(403).json({ error: 'Debes ser un jugador para realizar esta acción.' });
        return;
    }
    next();
};
