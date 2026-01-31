import express from "express";
import {
  createBooking,
  getAllBookings,
  getBookingById,
  deleteBooking,
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
router.get("/getbooking/:id", protect, getBookingById);
router.delete("/delete/:id", protect, deleteBooking);

export default router;
