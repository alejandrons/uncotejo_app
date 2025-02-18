import { NextFunction, Response } from 'express';
import { validationResult } from 'express-validator';

export const handleErrorResponse = (res: Response, error: unknown) => {
    const err = error as Error & { status?: number };
    res.status(err.status || 500).json({ error: err.message || HttpResponses[500] });
};

export const makeErrorResponse = (status: number, entity?: string) => {
    const message =
        typeof HttpResponses[status] === 'function'
            ? HttpResponses[status](entity)
            : HttpResponses[status];

    return { status, message };
};

export const HttpResponses: Record<number, string | ((entity?: string) => string)> = {
    400: (entity?: string) =>
        `Solicitud incorrecta. ${entity || 'La entidad'} contiene datos inválidos.`,
    401: 'No autorizado. Verifique sus credenciales.',
    403: 'Acceso prohibido. No tienes permisos para realizar esta acción.',
    404: (entity?: string) => `${entity || 'El recurso'} no fue encontrado.`,
    409: (entity?: string) => `Conflicto: ${entity || 'Ya existe el recurso solicitado.'}`,
    422: (entity?: string) =>
        `Entidad no procesable: ${entity || 'El recurso'} tiene datos inválidos.`,
    500: 'Error interno del servidor. Inténtelo más tarde o contacte a soporte.',
    503: 'Servicio no disponible. Estamos experimentando problemas técnicos.',
};

export const handleValidationErrors = (
    req: import('express').Request,
    res: Response,
    next: NextFunction,
): void => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        handleErrorResponse(
            res,
            makeErrorResponse(
                400,
                errors
                    .array()
                    .map((err) => err.msg)
                    .join('. '),
            ),
        );
        return;
    }
    next();
};
