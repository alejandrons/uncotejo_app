import { body } from 'express-validator';
import { ShieldForm, ShieldInterior } from '../utils/enums';

// Middleware de validación para crear un equipo
export const validateTeam = [
    body('name').isString().notEmpty().withMessage('El nombre del equipo es obligatorio.'),
    body('description').isString().notEmpty().withMessage('La descripción es obligatoria.'),
    body('slogan').isString().notEmpty().withMessage('El slogan es obligatorio.'),
    body('colorPrimary')
        .optional()
        .matches(/^#([A-Fa-f0-9]{6})$/)
        .withMessage('El color primario debe estar en formato hexadecimal (#RRGGBB).'),
    body('colorSecondary')
        .optional()
        .matches(/^#([A-Fa-f0-9]{6})$/)
        .withMessage('El color secundario debe estar en formato hexadecimal (#RRGGBB).'),
    body('shieldForm')
        .isIn(Object.values(ShieldForm))
        .withMessage(
            `Valor inválido para shieldForm. Debe ser uno de: ${Object.values(ShieldForm).join(', ')}`,
        ),
    body('shieldInterior')
        .optional()
        .isIn(Object.values(ShieldInterior))
        .withMessage(
            `Valor inválido para shieldInterior. Debe ser uno de: ${Object.values(ShieldInterior).join(', ')}`,
        ),
];
