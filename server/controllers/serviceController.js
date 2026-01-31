import Service from "../models/service.js";
import asyncHandler from "express-async-handler";

// @desc Create New Service
export const createService = asyncHandler(async (req, res) => {
  const service = await Service.create(req.body);
  res.status(201).json({
    success: true,
    message: "Service created successfully",
    data: service,
  });
});

// @desc Get All Services
export const getAllServices = asyncHandler(async (req, res) => {
  const services = await Service.find();
  res.status(200).json({
    success: true,
    count: services.length,
    data: services,
  });
});

// @desc Get Service By ID
export const getServiceById = asyncHandler(async (req, res) => {
  const service = await Service.findById(req.params.id);
  if (!service) {
    res.status(404);
    throw new Error("Adeeggan (Service) lama helin");
  }
  res.status(200).json({ success: true, data: service });
});

// @desc Update Service
export const updateService = asyncHandler(async (req, res) => {
  const service = await Service.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
  });

  if (!service) {
    res.status(404);
    throw new Error("Adeeggan lama helin, laguma sameyn karo update");
  }

  res.status(200).json({ success: true, data: service });
});

// @desc Delete Service
export const deleteService = asyncHandler(async (req, res) => {
  const service = await Service.findById(req.params.id);

  if (!service) {
    res.status(404);
    throw new Error("Adeeggan lama helin, lama tirtiri karo");
  }

  await service.deleteOne();
  res
    .status(200)
    .json({ success: true, message: "Service deleted successfully" });
});
