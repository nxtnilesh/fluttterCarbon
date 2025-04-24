import express from 'express';
import { protect } from '../middleware/auth.middleware.js';
import {
  getProfile,
  updateProfile,
  getTransactionHistory
} from '../controllers/profile.controller.js';

const router = express.Router();

// All routes are protected
router.use(protect);

router.get('/', getProfile);
router.put('/', updateProfile);
router.get('/transactions', getTransactionHistory);

export default router; 