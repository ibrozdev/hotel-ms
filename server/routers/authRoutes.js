import express from 'express';
import { login } from '../controllers/authController.js';
import { registerUser } from '../controllers/controller.js';
const authRoutes = express.Router();



authRoutes.post('/register',registerUser);
authRoutes.post("/login", login);

export default authRoutes;