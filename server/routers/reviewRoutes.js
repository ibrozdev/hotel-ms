import express from "express";
import { addReview, getServiceReviews } from "../controllers/reviewController.js";
import { protect } from "../middlewares/authMiddleware.js";

const router = express.Router();

router.route("/:serviceId")
  .post(protect, addReview)
  .get(getServiceReviews);

export default router;
