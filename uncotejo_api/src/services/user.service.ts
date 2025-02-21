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
     * ✅ Registro de usuario
     */
    static async register(data: IUser): Promise<Pick<IUser, 'id' | 'email'>> {
        const existingUser = await User.findOne({ where: { email: data.email } });

        if (existingUser) {
            throw makeErrorResponse(409, 'El email ya está registrado.');
        }

        const newUser = await User.create({
            ...data,
            role: data.role || Role.Player,
        });

        return { id: newUser.id, email: newUser.email };
    }

    /**
     * ✅ Inicio de sesión
     */
    static async login(
        email: string,
        password: string,
    ): Promise<{ token: string; user: Pick<IUser, 'id' | 'email' | 'role'> }> {
        const user = await User.findOne({ where: { email } });

        if (!user || !user.checkPassword(password)) {
            throw makeErrorResponse(401, 'Credenciales incorrectas.');
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
}
