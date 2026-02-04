import mongoose from "mongoose";

const serviceSchema = new mongoose.Schema(
  {
    serviceName: {
      type: String,
      required: [true, "Fadlan geli magaca adeegga"],
      unique: true,
      trim: true,
    },
    image: {
      type: String,
    },
    category: {
      type: String,
      required: [true, "Fadlan dooro qaybta (category)"],
      enum: ["Room", "Office", "Hall"],
    },
    maxCapacity: {
      type: Number,
      required: [true, "Fadlan geli xadiga dadka (capacity)"],
      default: 2,
    },
    amenities: {
      type: [String],
      default: [],
    },
    type: {
      type: String,
      required: [true, "Fadlan geli nooca (e.g. Luxury, Standard)"],
      default: "Standard",
    },
    price: {
      type: Number,
      required: [true, "Fadlan geli qiimaha"],
    },
    status: {
      type: String,
      enum: ["Available", "Booked"],
      default: "Available",
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
