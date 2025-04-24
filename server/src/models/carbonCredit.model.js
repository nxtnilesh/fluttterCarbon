import mongoose from 'mongoose';

const carbonCreditSchema = new mongoose.Schema({
  companyName: {
    type: String,
    required: [true, 'Please provide company name'],
    trim: true
  },
  companySector: {
    type: String,
    required: [true, 'Please specify company sector'],
    trim: true
  },
  credits: {
    type: Number,
    required: [true, 'Please specify number of credits'],
    min: [0, 'Credits cannot be negative']
  },
  pricePerCredit: {
    type: Number,
    required: [true, 'Please specify price per credit'],
    min: [0, 'Price cannot be negative']
  },
  description: {
    type: String,
    required: [true, 'Please provide a description'],
    trim: true
  },
  seller: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  status: {
    type: String,
    enum: ['available', 'sold', 'pending'],
    default: 'available'
  },
  verificationStatus: {
    type: String,
    enum: ['pending', 'verified', 'rejected'],
    default: 'pending'
  },
  verificationDocuments: [{
    type: String,
    required: [true, 'Please provide verification documents']
  }]
}, {
  timestamps: true
});

const CarbonCredit = mongoose.model('CarbonCredit', carbonCreditSchema);
export default CarbonCredit; 