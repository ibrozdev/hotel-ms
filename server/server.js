import express from 'express';
import morgan from 'morgan';
import dotenv from 'dotenv';
import connectDB from './config/db.js';
import authRoutes from './routers/authRoutes.js';
import userRoutes from './routers/routes.js';
dotenv.config();


connectDB();

const app = express();
const PORT = process.env.PORT | 5000;
app.use(express.json());
app.use(morgan('combined'));

app.use('/api/auth',authRoutes);
app.use('/api/users',userRoutes);




app.get('/',(req,res)=>{
    res.send('hello from hotel ms');
})




app.listen(PORT,(req,res)=>{
    console.log(`server is running on this url http://localhost:${PORT}`);
})