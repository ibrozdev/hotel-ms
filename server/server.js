import express from 'express';
import dotenv from 'dotenv';
import connectDB from './config/db.js';
import authRoutes from './routers/authRoutes.js';
import bookingRoutes from './routers/bookingRouter.js';
dotenv.config();

// Connect to MongoDB
connectDB();

const app = express();

// Middleware
app.use(express.json());

app.use('/api/auth',authRoutes);
app.use('/api/booking',bookingRoutes);





// Test route
app.get("/", (req, res) => {
  res.send("Hello from Hotel MS API 🚀");
});

// Port
const PORT = process.env.PORT || 5000;

// Start server
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
