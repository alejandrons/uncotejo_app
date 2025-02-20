import { Router, Request, Response } from 'express';
import UserService from '../services/user.service';
import { IUser } from '../views/user';
import { authMiddleware, IAuthRequest } from '../middlewares/auth.middleware';
import {
    validateRegister,
    validateLogin,
    validateUpdateUser,
} from '../middlewares/user.middleware';
import { handleErrorResponse, handleValidationErrors } from '../utils/errorHandler';

const router = Router();

/**
 * ✅ Registro de usuario
 */
router.post(
    '/register',
    validateRegister,
    handleValidationErrors,
    async (req: Request<{}, {}, IUser>, res: Response) => {
        try {
            const user = await UserService.register(req.body);
            res.status(201).json(user);
        } catch (error) {
            handleErrorResponse(res, error);
        }
    },
);

/**
 * ✅ Inicio de sesión
 */
router.post(
    '/login',
    validateLogin,
    handleValidationErrors,
    async (req: Request<{}, {}, Pick<IUser, 'email' | 'password'>>, res: Response) => {
        try {
            const { email, password } = req.body;
            const result = await UserService.login(email, password);
            res.json(result);
        } catch (error) {
            handleErrorResponse(res, error);
        }
    },
);

/**
 * ✅ Actualización de usuario
 */
router.put(
    '/users/:id',
    authMiddleware,
    validateUpdateUser,
    handleValidationErrors,
    async (req: IAuthRequest, res: Response) => {
        try {
            const userId = parseInt(req.params.id);
            const updatedUser = await UserService.updateUser(userId, req.body);
            res.json(updatedUser);
        } catch (error) {
            handleErrorResponse(res, error);
        }
    },
);

export default router;
