import express from 'express';
import dotenv from 'dotenv';
import connectDB from './config/db.js';
import authRoutes from './routers/authRoutes.js';
import userRoute from './routers/routes.js'
import serviceRoute from './routers/serviceRoutes.js';
import bookingRoutes from './routers/bookingRouter.js';
import { errorHandler } from './middlewares/errorMiddleware.js';
import helmet from 'helmet';
import mongoSanitize from 'express-mongo-sanitize';
import cors from 'cors';
import morgan from 'morgan';
dotenv.config();
const app = express();

app.use(morgan('dev'));

// Middleware for security headers
// Middleware for security headers
app.use(helmet());

import { limiter } from './middlewares/rateLimiter.js';
app.use('/api', limiter);



app.use(cors());

// Connect to MongoDB
connectDB();


// Middleware
app.use(express.json({ limit: "30mb" }));
app.use(express.urlencoded({ extended: true, limit: "30mb" }));


import reviewRoutes from './routers/reviewRoutes.js';

app.use('/api/auth',authRoutes);
app.use('/api/users',userRoute);
app.use("/api/services", serviceRoute);
app.use('/api/booking',bookingRoutes);
app.use('/api/reviews', reviewRoutes);


app.use(errorHandler);



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
