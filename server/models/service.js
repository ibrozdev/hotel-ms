import mongoose from "mongoose";

const serviceSchema = new mongoose.Schema(
  {
    serviceName: {
      type: String,
      required: [true, "Fadlan geli magaca adeegga"],
      unique: true,
      trim: true,
    },
    category: {
      type: String,
      required: [true, "Fadlan dooro qaybta (category)"],
      enum: ["Room", "Hall", "Office"],
    },
    type: {
      type: String,
      required: [true, "Fadlan geli nooca (e.g. Luxury, Standard)"],
    },
    price: {
      type: Number,
      required: [true, "Fadlan geli qiimaha"],
    },
    isAvailable: {
      type: Boolean,
      default: true,
    },
    description: {
      type: String,
      required: [true, "Fadlan geli sharaxaadda adeegga"],
    },
  },
  { timestamps: true },
);

const Service =
  mongoose.models.Service || mongoose.model("Service", serviceSchema);
export default Service;
