// routes/bookingRoutes.js
import express from "express";
import {
  createBooking,
  getAllBookings,
  getBookingById,
  updateBooking,
  deleteBooking,
} from "../controllers/BookingController.js";

const bookingRoutes = express.Router();

bookingRoutes.post("/create", createBooking);
bookingRoutes.get("/getbooking", getAllBookings);
bookingRoutes.get("/getbooking/:id", getBookingById);
bookingRoutes.put("/update/:id", updateBooking);
bookingRoutes.delete("/delete/:id", deleteBooking);

export default bookingRoutes;
