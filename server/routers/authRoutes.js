import express from 'express';
import { login, registerUser } from '../controllers/authController.js';
const authRoutes = express.Router();



import { loginValidation, registerValidation } from '../middlewares/validation.js';

authRoutes.post("/register", registerValidation, registerUser);
authRoutes.post("/login", loginValidation, login);

export default authRoutes;