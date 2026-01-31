import Service from "../models/service.js";
import { superbase,BUCKET_NAME } from "../config/supabase.js";
import asyncHandler from "express-async-handler";

// @desc Create New Service
export const createService = asyncHandler(async (req, res) => {
  let imageUrl = "https://via.placeholder.com/150";

  if (req.file) {
    // Waxaan isticmaalaynaa Buffer (RAM) halkii aan file-path isticmaali lahayn
    const fileName = `${Date.now()}-${req.file.originalname}`;

    const { data, error } = await superbase.storage
      .from(BUCKET_NAME)
      .upload(fileName, req.file.buffer, {
        contentType: req.file.mimetype,
        upsert: false,
      });

    if (error) {
      res.status(400);
      throw new Error("Supabase Upload Error: " + error.message);
    }

    const { data: publicUrlData } = superbase.storage
      .from(BUCKET_NAME)
      .getPublicUrl(fileName);

    imageUrl = publicUrlData.publicUrl;
  }

  const service = await Service.create({ ...req.body, image: imageUrl });
  res.status(201).json({ success: true, data: service });
});

export const getAllServices = asyncHandler(async (req, res) => {
  const services = await Service.find();
  res.status(200).json({
    success: true,
    count: services.length,
    data: services,
  });
});


export const getServiceById = asyncHandler(async (req, res) => {
  const service = await Service.findById(req.params.id);
  if (!service) {
    res.status(404);
    throw new Error("Adeeggan (Service) lama helin");
  }
  res.status(200).json({ success: true, data: service });
});



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
