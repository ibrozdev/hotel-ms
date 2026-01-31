import User from "../models/User.js";
import jwt from "jsonwebtoken";
import asyncHandler from "express-async-handler";

// Generates Token
const generateToken = (id, role) => {
  return jwt.sign({ id, role }, process.env.JWT_SECRET, { expiresIn: "1d" });
};

// @desc Register User
export const registerUser = asyncHandler(async (req, res) => {
  const { name, email, password, role } = req.body;

  const userExists = await User.findOne({ email });
  if (userExists) {
    res.status(400);
    throw new Error("User horay ayuu u jiray");
  }

  const user = await User.create({ name, email, password, role });

  res.status(201).json({
    success: true,
    message: "User registered successfully",
    data: {
      _id: user._id,
      name: user.name,
      email: user.email,
      role: user.role,
      token: generateToken(user._id, user.role),
    },
  });
});

// @desc Login User
export const login = asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email });

  if (user && (await user.matchPassword(password))) {
    res.json({
      success: true,
      message: "Logged in successfully",
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
        token: generateToken(user._id, user.role),
      },
    });
  } else {
    res.status(401);
    throw new Error("Email ama Password khaldan");
  }
});

export const getAllUsers = asyncHandler(async (req, res) => {
  const users = await User.find().select("-password");
  res.json({ success: true, count: users.length, data: users });
});

export const getUserById = asyncHandler(async (req, res) => {
  const user = await User.findById(req.params.id).select("-password");
  if (!user) {
    res.status(404);
    throw new Error("User la waayay");
  }
  res.json({ success: true, data: user });
});

export const updateUser = asyncHandler(async (req, res) => {
  const user = await User.findById(req.params.id);
  if (!user) {
    res.status(404);
    throw new Error("User la waayay");
  }

  user.name = req.body.name || user.name;
  user.email = req.body.email || user.email;
  user.role = req.body.role || user.role;
  if (req.body.password) user.password = req.body.password;

  const updatedUser = await user.save();
  res.json({ success: true, message: "User updated", data: updatedUser });
});

export const deleteUser = asyncHandler(async (req, res) => {
  const user = await User.findById(req.params.id);
  if (!user) {
    res.status(404);
    throw new Error("User la waayay");
  }
  await user.deleteOne();
  res.json({ success: true, message: "User deleted" });
});
