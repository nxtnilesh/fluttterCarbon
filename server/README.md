# Carbon Credit Trading Platform Backend

A Node.js/Express backend for a carbon credit trading platform that allows companies to buy and sell carbon credits.

## Features

- User authentication (register/login)
- Role-based access control (buyer/seller)
- Carbon credit listing and management
- Transaction processing
- Profile management
- Transaction history

## Prerequisites

- Node.js (v14 or higher)
- MongoDB
- npm or yarn

## Installation

1. Clone the repository
```bash
git clone <repository-url>
cd carbon-credit-trading
```

2. Install dependencies
```bash
npm install
```

3. Create a `.env` file in the root directory with the following variables:
```
PORT=5000
MONGODB_URI=mongodb://localhost:27017/carbon-credit-trading
JWT_SECRET=your_jwt_secret_key_here
JWT_EXPIRES_IN=7d
```

4. Start the development server
```bash
npm run dev
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user

### Carbon Credits
- `GET /api/carbon-credits` - Get all available carbon credits
- `GET /api/carbon-credits/:id` - Get a specific carbon credit
- `POST /api/carbon-credits` - Create a new carbon credit (seller only)
- `POST /api/carbon-credits/:id/buy` - Buy carbon credits (buyer only)

### Profile
- `GET /api/profile` - Get user profile
- `PUT /api/profile` - Update user profile
- `GET /api/profile/transactions` - Get transaction history

## Technologies Used

- Node.js
- Express.js
- MongoDB
- Mongoose
- JWT for authentication
- bcryptjs for password hashing

## Security Features

- Password hashing
- JWT authentication
- Role-based access control
- Input validation
- Error handling

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request 