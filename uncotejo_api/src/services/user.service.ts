import User from '../models/user.model';
import jwt from 'jsonwebtoken';
import { IUser } from '../views/user';
import { Role } from '../utils/enums';

const JWT_SECRET = process.env.JWT_SECRET || 'secreto_super_seguro';

export default class UserService {
    static async register(data: IUser): Promise<Pick<IUser, 'id' | 'email'>> {
        const existingUser = await User.findOne({ where: { email: data.email } });

        if (existingUser) {
            throw new Error('El email ya está registrado.');
        }

        const newUser = await User.create({
            ...data,
            role: data.role || Role.Player,
        });

        return { id: newUser.id, email: newUser.email };
    }

    static async login(
        email: string,
        password: string,
    ): Promise<{ token: string; user: Pick<IUser, 'id' | 'email' | 'role'> }> {
        const user = await User.findOne({ where: { email } });

        if (!user || !user.checkPassword(password)) {
            throw new Error('Credenciales incorrectas');
        }

        const token = jwt.sign({ id: user.id, role: user.role }, JWT_SECRET, {
            expiresIn: '24h',
        });

        return { token, user: { id: user.id, email: user.email, role: user.role } };
    }

    static async updateUser(userId: number, data: Partial<IUser>): Promise<IUser> {
        const user = await User.findByPk(userId);
        if (!user) throw new Error('Usuario no encontrado.');

        if (data.role && data.role === Role.Admin) {
            throw new Error('No puedes asignar el rol de admin.');
        }

        await user.update(data);
        return user;
    }
}
