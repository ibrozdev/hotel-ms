import  exprss from 'express';
import { deleteUser, getAllUsers, getUserById, registerUser, updateUser } from '../controllers/authController.js';
const route = exprss.Router();

route.post('/register',registerUser);
route.get('/getUsers',getAllUsers);
route.get('/getUsers/:id',getUserById);
route.put('/updateUser/:id',updateUser);
route.delete('/deleteUser/:id',deleteUser);



export default route;