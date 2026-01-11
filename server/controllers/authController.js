import User from '../models/User.js'
import JWT from 'jsonwebtoken';
import bcrypt from 'bcryptjs';









export const login = async  (req,res)=>{
    try {
        const { email, password } = req.body
        const user = await User.findOne({ email });
        if (!user) return res.status(400).json({ message: "User does not exist" });

        const isMatch = await bcrypt.compare(password,user.password);
        if(!isMatch) return res.status(400).json({ message: "invalid password" });

        const token = JWT.sign(
          { id: user._id, role: user.role },
          process.env.JWT_SECRET,
          {expiresIn: '1d'}
        );

        res.status(200).json({
            success: true,
            message: 'User Logged in successfully',
            user:{
                id: user._id,
                name: user.name,
                userEmail: user.email,
                role: user.role,
                token
            }
        })

    } catch (err) {
        res.status(500).json({ success: false, Error: err.message });       
    }
}
