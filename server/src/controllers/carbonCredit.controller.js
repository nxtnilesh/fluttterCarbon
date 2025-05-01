import CarbonCredit from '../models/carbonCredit.model.js';
import Transaction from '../models/transaction.model.js';

export const createCarbonCredit = async (req, res) => {
  try {
    const { companyName, companySector, credits, pricePerCredit, description, verificationDocuments } = req.body;

    const carbonCredit = await CarbonCredit.create({
      companyName,
      companySector,
      credits,
      pricePerCredit,
      description,
      verificationDocuments,
      // seller: req.user._id
      seller: "6809e30f9db5a0f3ebb3ff00"
    });

    res.status(201).json({
      success: true,
      data: carbonCredit
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error creating carbon credit',
      error: error.message
    });
  }
};

export const getCarbonCredits = async (req, res) => {
  try {
    const carbonCredits = await CarbonCredit.find({ status: 'available' })
      .populate('seller', 'name email companyName companySector');

    res.status(200).json({
      success: true,
      count: carbonCredits.length,
      data: carbonCredits
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error fetching carbon credits',
      error: error.message
    });
  }
};

export const getCarbonCredit = async (req, res) => {
  try {
    const carbonCredit = await CarbonCredit.findById(req.params.id)
      .populate('seller', 'name email companyName companySector');

    if (!carbonCredit) {
      return res.status(404).json({
        message: 'Carbon credit not found'
      });
    }

    res.status(200).json({
      success: true,
      data: carbonCredit
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error fetching carbon credit',
      error: error.message
    });
    
    // res.status(200).json({
    //   success: false,
    //   data: "null"
    // });

  }
};

export const buyCarbonCredit = async (req, res) => {
  try {
    const { credits } = req.body;
    console.log("ai", credits);
    console.log("parmas", req.params.id);
    
    const carbonCredit = await CarbonCredit.findById(req.params.id);
    
    if (!carbonCredit) {
      return res.status(404).json({
        message: 'Carbon credit not found'
      });
    }
    console.log("cardbonCredit Data");

    if (carbonCredit.status !== 'available') {
      return res.status(400).json({
        message: 'Carbon credit is not available for purchase'
      });
    }

    if (credits > carbonCredit.credits) {
      return res.status(400).json({
        message: 'Not enough credits available'
      });
    }

    // Create transaction
    const transaction = await Transaction.create({
      buyer: req.user._id,
      seller: carbonCredit.seller,
      carbonCredit: carbonCredit._id,
      credits,
      pricePerCredit: carbonCredit.pricePerCredit,
      totalAmount: credits * carbonCredit.pricePerCredit
    });

    // Update carbon credit
    carbonCredit.credits -= credits;
    if (carbonCredit.credits === 0) {
      carbonCredit.status = 'sold';
    }
    await carbonCredit.save();

    res.status(201).json({
      success: true,
      data: transaction
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error processing purchase',
      error: error.message
    });
  }
}; 