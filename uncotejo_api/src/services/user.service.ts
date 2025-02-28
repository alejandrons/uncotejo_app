import User from '../models/user.model';
import jwt from 'jsonwebtoken';
import { IUser } from '../views/user';
import { Role } from '../utils/enums';
import { makeErrorResponse } from '../utils/errorHandler';

const JWT_SECRET = process.env.JWT_SECRET;
if (!JWT_SECRET) {
    throw new Error('JWT_SECRET no está definido en las variables de entorno.');
}

export default class UserService {
    /**
     * ✅ Inicio de sesión
     */
    static async loginOrRegister(
        name: string,
        email: string,
    ): Promise<{ token: string; user: Pick<IUser, 'id' | 'email' | 'role'> }> {
        let user = await User.findOne({ where: { email } });

        if (!user) {
            const newUser = await User.create({
                name,
                email,
                role: Role.Player,
            });
            user = newUser;
        }

        const token = jwt.sign({ id: user.id, role: user.role }, JWT_SECRET!, {
            expiresIn: '24h',
        });

        return { token, user: { id: user.id, email: user.email, role: user.role } };
    }

    /**
     * ✅ Actualización de usuario
     */
    static async updateUser(userId: number, data: Partial<IUser>): Promise<IUser> {
        const user = await User.findByPk(userId);
        if (!user) throw makeErrorResponse(404, 'Usuario no encontrado.');

        if (data.role && data.role === Role.Admin) {
            throw makeErrorResponse(403, 'No puedes asignar el rol de admin.');
        }

        await user.update(data);
        return user;
    }

    static async getUserById(userId: number): Promise<IUser | null> {
        const user = await User.findByPk(userId);
        if (!user) throw makeErrorResponse(404, 'Usuario no encontrado.');
        return user;
    }

    static generateNewToken = async (userId: number) => {
        const user = await UserService.getUserById(userId);
        return jwt.sign({ id: user!.id }, process.env.JWT_SECRET!, { expiresIn: '24h' });
    };
}
