import dotenv from 'dotenv';
import sequelize from './config/db';
import app from './app';

dotenv.config();

const PORT = process.env.PORT || 3000;

sequelize
    .authenticate()
    .then(async () => {
        console.log('Database connection established successfully.');

        if (process.env.DB_SYNC === 'true') {
            await sequelize.sync({ alter: true });
            console.log('Database synchronized successfully.');
        }

        app.listen(PORT, () => {
            console.log(`Server running on http://localhost:${PORT}`);
        });
    })
    .catch((error) => {
        console.error('Unable to connect to the database:', error);
    });
