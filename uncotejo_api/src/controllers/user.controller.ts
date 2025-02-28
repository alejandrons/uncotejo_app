import { Router, Request, Response } from 'express';
import UserService from '../services/user.service';
import { IUser } from '../views/user';
import { authMiddleware, IAuthRequest } from '../middlewares/auth.middleware';
import { validateLogin, validateUpdateUser } from '../middlewares/user.middleware';
import { handleErrorResponse, handleValidationErrors } from '../utils/errorHandler';

const router = Router();

/**
 * ✅ Inicio de sesión
 */
router.post(
    '/login',
    validateLogin,
    handleValidationErrors,
    async (
        req: Request<{}, {}, Pick<IUser, 'name' | 'email'>>,
        res: Response,
    ) => {
        try {
            const { name, email } = req.body;
            const result = await UserService.loginOrRegister(name, email);
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
            const updatedUser: IUser = await UserService.updateUser(userId, req.body);
            res.json(updatedUser);
        } catch (error) {
            handleErrorResponse(res, error);
        }
    },
);

export default router;
