import { Sequelize } from 'sequelize-typescript';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config();

const sequelize = new Sequelize({
  database: process.env.DB_NAME, 
  username: process.env.DB_USER, 
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST, 
  port: parseInt(process.env.DB_PORT || '3306'), 
  dialect: process.env.DB_DIALECT as 'mysql',
  models: [path.resolve(__dirname, '../models')],  }
);

export default sequelize;
