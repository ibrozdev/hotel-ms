import express from "express";
import {
  createBooking,
  getAllBookings,
  getBookingById,
  updateBooking,
  getRevenueStats,
  getMyBookings, // Import new method
  deleteBooking
} from "../controllers/BookingController.js";
import { protect, authorize } from "../middlewares/authMiddleware.js";
import { bookingValidation } from "../middlewares/validation.js";

const router = express.Router();

router.post("/create", protect, bookingValidation, createBooking);
router.get(
  "/getbooking",
  protect,
  authorize("admin", "manager"),
  getAllBookings,
);
router.get("/mybooking", protect, getMyBookings); // Removed :id, added getMyBookings
router.get("/mybooking/:id", protect, getBookingById); // Keep this for fetching single if needed
router.put(
  "/update/:id",
  protect,
  authorize("admin", "manager"),
  updateBooking,
);
router.delete(
  "/delete/:id",
  protect,
  authorize("admin", "manager"),
  deleteBooking,
);

router.get("/stats", protect, authorize("admin"), getRevenueStats);
export default router;
