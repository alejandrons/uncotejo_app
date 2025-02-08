import { Router, Request, Response } from 'express';
import UserService from '../services/user.service';
import { IUser } from '../views/user';
import { authMiddleware, IAuthRequest } from '../middlewares/auth.middleware';
import {
    validateRegister,
    validateLogin,
    validateUpdateUser,
} from '../middlewares/validate.middleware';

const router = Router();

router.post('/register', validateRegister, async (req: Request<{}, {}, IUser>, res: Response) => {
    try {
        const user = await UserService.register(req.body);
        res.status(201).json(user);
    } catch (error: unknown) {
        const err = error as Error & { status?: number };
        res.status(err.status || 500).json({
            error: err.message || 'Error desconocido.',
        });
    }
});

router.post(
    '/login',
    validateLogin,
    async (req: Request<{}, {}, Pick<IUser, 'email' | 'password'>>, res: Response) => {
        try {
            const { email, password } = req.body;
            const result = await UserService.login(email, password);
            res.json(result);
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 500).json({
                error: err.message || 'Error desconocido.',
            });
        }
    },
);

router.put(
    '/users/:id',
    authMiddleware,
    validateUpdateUser,
    async (req: IAuthRequest, res: Response) => {
        try {
            const userId = parseInt(req.params.id);
            const { user } = req;
            const updatedUser = await UserService.updateUser(userId, req.body);
            res.json(updatedUser);
        } catch (error: unknown) {
            const err = error as Error & { status?: number };
            res.status(err.status || 500).json({
                error: err.message || 'Error desconocido.',
            });
        }
    },
);

export default router;
