import user from './controllers/user.controller';
import team from './controllers/team.controller';
import match from './controllers/match.controller';
import { Router } from 'express';

const router = Router();

router.use('/auth', user);
router.use('/team', team);
router.use('/match', match);

export default router;
