import mongoose from "mongoose";
import bcrypt from "bcryptjs";

const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: [true, "Fadlan magaca geli"] },
    email: {
      type: String,
      required: [true, "Fadlan emailka geli"],
      unique: true,
    },
    phone: { type: String },
    role: {
      type: String,
      enum: ["admin", "manager", "customer"],
      default: "customer",
    },
    password: { type: String, required: [true, "Fadlan password-ka geli"] },
  },
  { timestamps: true },
);

// Advanced: Password-ka hash gareey intaan la keydin
userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
});

// Advanced: Method lagu barbardhigo password-ka
userSchema.methods.matchPassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

export default mongoose.model("Users", userSchema);
