import express from 'express';
import { deleteUser, getAllUsers, getUserById, updateUser } from '../controllers/authController.js';
import { protect, authorize } from '../middlewares/authMiddleware.js';
const route = express.Router();



route.get('/getUsers', protect, authorize('admin'), getAllUsers);
route.get('/getUsers/:id', protect, authorize('admin'), getUserById);
route.put('/updateUser/:id', protect, authorize('admin'), updateUser);
route.delete('/deleteUser/:id', protect, authorize('admin'), deleteUser);



export default route;