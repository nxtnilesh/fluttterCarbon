import User from '../models/user.model.js';
import CarbonCredit from '../models/carbonCredit.model.js';
import Transaction from '../models/transaction.model.js';

export const getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);
    
    // Get user's carbon credits (if seller)
    const carbonCredits = await CarbonCredit.find({ seller: req.user._id });
    
    // Get user's transactions
    const transactions = await Transaction.find({
      $or: [{ buyer: req.user._id }, { seller: req.user._id }]
    })
    .populate('buyer', 'name email companyName')
    .populate('seller', 'name email companyName')
    .populate('carbonCredit', 'companyName companySector');

    res.status(200).json({
      success: true,
      data: {
        user,
        carbonCredits,
        transactions
      }
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error fetching profile',
      error: error.message
    });
  }
};

export const updateProfile = async (req, res) => {
  try {
    const { fullName, companyName, companySector } = req.body;
    
    const user = await User.findByIdAndUpdate(
      req.user._id,
      { fullName, companyName, companySector },
      { new: true, runValidators: true }
    );

    res.status(200).json({
      success: true,
      data: user
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error updating profile',
      error: error.message
    });
  }
};

export const getTransactionHistory = async (req, res) => {
  try {
    const transactions = await Transaction.find({
      $or: [{ buyer: req.user._id }, { seller: req.user._id }]
    })
    .populate('buyer', 'name email companyName')
    .populate('seller', 'name email companyName')
    .populate('carbonCredit', 'companyName companySector')
    .sort('-createdAt');

    res.status(200).json({
      success: true,
      count: transactions.length,
      data: transactions
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error fetching transaction history',
      error: error.message
    });
  }
}; 