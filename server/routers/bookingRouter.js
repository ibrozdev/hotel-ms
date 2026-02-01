import express from "express";
import {
  createBooking,
  getAllBookings,
  getBookingById,
  deleteBooking,
  getRevenueStats
} from "../controllers/BookingController.js";
import { protect, authorize } from "../middlewares/authMiddleware.js";

const router = express.Router();

router.post("/create", protect, createBooking);
router.get(
  "/getbooking",
  protect,
  authorize("admin", "manager"),
  getAllBookings,
);
router.get("/mybooking/:id", protect, getBookingById);
router.delete("/delete/:id", protect, deleteBooking);

router.get("/stats", protect, authorize("admin"), getRevenueStats);
export default router;
