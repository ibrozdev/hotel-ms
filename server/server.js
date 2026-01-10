import express from "express";
import morgan from "morgan";
import dotenv from "dotenv";

import connectDB from "./config/db.js";
import authRoutes from "./routers/authRoutes.js";
import userRoutes from "./routers/routes.js";
import serviceRoutes from "./routers/serviceRoutes.js";


// Load env variables FIRST
dotenv.config();

// Connect to MongoDB
connectDB();

const app = express();

// Middleware
app.use(express.json());
app.use(morgan("dev"));

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);
app.use("/api/services", serviceRoutes);


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
