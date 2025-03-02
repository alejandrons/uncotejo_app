import dotenv from 'dotenv';
import sequelize from './config/db';
import app from './app';

dotenv.config();

const PORT = Number(process.env.PORT) || 3000;
const DB_HOST = process.env.DB_HOST || 'localhost';

sequelize
    .authenticate()
    .then(async () => {
        console.log('Database connection established successfully.');

        if (process.env.DB_SYNC === 'true') {
            await sequelize.sync({ alter: true });
            console.log('Database synchronized successfully.');
        }

        app.listen(PORT, DB_HOST, () => {
            console.log(`Server running on http://${DB_HOST}:${PORT}`);
        });
    })
    .catch((error) => {
        console.error('Unable to connect to the database:', error);
    });
