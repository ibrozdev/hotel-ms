import mongoose from "mongoose";

const bookingSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Users", // Magaca model-ka User-kaaga
      required: true,
    },
    service: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Service",
      required: true,
    },
    checkInDate: {
      type: Date,
      required: [true, "Fadlan geli taariikhda check-in-ka"],
    },
    checkOutDate: {
      type: Date,
      required: [true, "Fadlan geli taariikhda check-out-ka"],
    },
    totalPrice: {
      type: Number,
      required: true,
    },
    bookingId: {
      type: String,
      unique: true,
      required: true,
    },
    status: {
      type: String,
      enum: ["pending", "confirmed", "cancelled"],
      default: "confirmed",
    },
    paymentMethod: {
      type: String,
      enum: ["Card", "PayAtHotel"],
      required: true,
    },
    paymentStatus: {
      type: String,
      enum: ["Pending", "Paid", "Failed"],
      default: "Pending",
    },
  },
  { timestamps: true },
);

const Booking = mongoose.model("booking", bookingSchema);
export default Booking;
