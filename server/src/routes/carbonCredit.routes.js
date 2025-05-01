import express from 'express';
import { protect, authorize } from '../middleware/auth.middleware.js';
import {
  createCarbonCredit,
  getCarbonCredits,
  getCarbonCredit,
  buyCarbonCredit
} from '../controllers/carbonCredit.controller.js';

const router = express.Router();

router.get('/', getCarbonCredits);
router.get('/:id', getCarbonCredit);

// Protected routes
router.use(protect);

// router.post('/', authorize('seller'), createCarbonCredit);
// router.post('/:id/buy', authorize('buyer'), buyCarbonCredit);

router.post('/', createCarbonCredit);
router.post('/:id/buy', buyCarbonCredit);

export default router; 