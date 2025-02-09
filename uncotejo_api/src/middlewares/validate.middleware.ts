import { Request, Response, NextFunction } from 'express';

export function validateRegister(req: Request, res: Response, next: NextFunction): void {
    const { firstName, lastName, email, password } = req.body;

    if (!firstName || !lastName || !email || !password) {
        res.status(400).json({ error: 'Todos los campos obligatorios deben estar completos.' });
        return;
    }

    if (!/\S+@\S+\.\S+/.test(email)) {
        res.status(400).json({ error: 'Formato de email inválido.' });
        return;
    }

    next();
}

export function validateLogin(req: Request, res: Response, next: NextFunction): void {
    const { email, password } = req.body;

    if (!email || !password) {
        res.status(400).json({ error: 'Email y contraseña son obligatorios.' });
        return;
    }

    if (!/\S+@\S+\.\S+/.test(email)) {
        res.status(400).json({ error: 'Formato de email inválido.' });
        return;
    }

    next();
}

export function validateUpdateUser(req: Request, res: Response, next: NextFunction): void {
    if (!req.body || Object.keys(req.body).length === 0) {
        res.status(400).json({ error: 'Debe enviar al menos un campo para actualizar.' });
        return;
    }

    if (req.body.email && !/\S+@\S+\.\S+/.test(req.body.email)) {
        res.status(400).json({ error: 'Formato de email inválido.' });
        return;
    }

    next();
}
