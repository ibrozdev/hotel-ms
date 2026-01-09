import User from "../models/User.js";
import JWT from "jsonwebtoken";
import bcrypt from "bcryptjs";



export const registerUser = async (req,res)=>{
    try {
        const {name,email,password,role} = req.body;

        let user = await User.findOne({ email });
        if (user) return res.status(400).json({ message: "User already exists" });

        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password,salt);

        user = new   User({ name, email, password: hashedPassword,role});
     
        const savedData = await user.save();

        res.status(201).json({ success: true, message: "User registered successfully",data: savedData})
    } catch (err) {
        res.status(500).json({ success: false, Error: err.message });
    }
}


export const getAllUsers = async (req,res)=>{
    try {
        const users = await User.find().select("-password");
        res
          .status(200)
          .json({ success: true, count: users.length, data: users });
        
    } catch (err) {
        res.status(500).json({ success: false, Error: err.message });
    }
}

export const getUserById = async (req,res)=>{
    try {
        const user = await User.findById(req.params.id).select('-password');
        if(!user) return res.status(404).json({ success: false, message: "User not found" });
        res.status(200).json({ success: true, data: user });
    } catch (err) {
        res.status(500).json({ success: false, Error: err.message });
    }
}


export const updateUser = async (req,res)=>{
    try {
        if (req.body.password) {
            const salt = await bcrypt.genSalt(10);
            req.body.password = await bcrypt.hash(req.body.password,salt);
        }
        const updatedUser = await User.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true }
        ).select('-password');
        if(!updatedUser) return res.status(404).json({ success: false, message: "User not found" });
        res.status(200).json({ success: true, message: "User updated successfully", data: updatedUser });
    } catch (err) {
        res.status(500).json({ success: false, Error: err.message });
    }
}


export const deleteUser = async (req,res)=>{
    try {
        const deletedUser = await User.findByIdAndDelete(req.params.id);
        if(!deletedUser) return res.status(404).json({ success: false, message: "User not found" });
        res.status(200).json({ success: true, message: "User deleted successfully" });
    } catch (err) {
        res.status(500).json({ success: false, Error: err.message });
    }
}




