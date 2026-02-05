import Review from "../models/Review.js";
import Service from "../models/service.js";
import asyncHandler from "express-async-handler";

// @desc Add a Review
export const addReview = asyncHandler(async (req, res) => {
  const { rating, comment } = req.body;
  const serviceId = req.params.serviceId;
  const userId = req.user.id || req.user._id;

  const service = await Service.findById(serviceId);
  if (!service) {
    res.status(404);
    throw new Error("Service not found");
  }

  // Check if user already reviewed
  const alreadyReviewed = await Review.findOne({ user: userId, service: serviceId });
  if (alreadyReviewed) {
    res.status(400);
    throw new Error("You have already reviewed this service");
  }

  const review = await Review.create({
    user: userId,
    service: serviceId,
    rating: Number(rating),
    comment,
  });

  res.status(201).json({ success: true, data: review });
});

// @desc Get Reviews for a Service
export const getServiceReviews = asyncHandler(async (req, res) => {
  const reviews = await Review.find({ service: req.params.serviceId })
    .populate("user", "name")
    .sort("-createdAt");

  res.status(200).json({ success: true, count: reviews.length, data: reviews });
});
