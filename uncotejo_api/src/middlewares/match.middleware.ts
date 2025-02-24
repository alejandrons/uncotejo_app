import { NextFunction } from 'express';
import { body, validationResult } from 'express-validator';
import { handleErrorResponse, makeErrorResponse } from '../utils/errorHandler';

export const validateCreateMatch = [
    body('possibleDates')
        .isObject()
        .withMessage('El campo possibleDates es obligatorio y debe ser un objeto válido.'),

    body('fixedTime')
        .matches(/^([0-1]\d|2[0-3]):([0-5]\d)$/)
        .withMessage('El campo fixedTime es obligatorio y debe estar en formato HH:mm.'),
];
