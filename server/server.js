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
dotenv.config();
const app = express();

// Middleware for security headers
app.use(helmet());



app.use(cors());

// Connect to MongoDB
connectDB();


// Middleware
app.use(express.json({ limit: "30mb" }));
app.use(express.urlencoded({ extended: true, limit: "30mb" }));


app.use('/api/auth',authRoutes);
app.use('/api/users',userRoute);
app.use("/api/services", serviceRoute);
app.use('/api/booking',bookingRoutes);


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
