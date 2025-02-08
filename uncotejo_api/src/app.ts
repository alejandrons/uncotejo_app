import express, { Application } from 'express';
import morgan from 'morgan';
import cors from 'cors';
import routes from './routes';

const app: Application = express();

app.use(morgan('dev'));
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));


app.use('', routes);

export default app;
