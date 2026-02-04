import Service from "../models/service.js";
import { superbase,BUCKET_NAME } from "../config/supabase.js";
import asyncHandler from "express-async-handler";
import { json } from "express";

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

  const { price, maxCapacity, amenities } = req.body;
  
  const serviceData = {
    ...req.body,
    price: price ? Number(price) : 0,
    maxCapacity: maxCapacity ? Number(maxCapacity) : 2,
    amenities: Array.isArray(amenities) ? amenities : (amenities ? amenities.split(',') : []),
    image: imageUrl
  };

  const service = await Service.create(serviceData);
  res.status(201).json({ success: true, data: service });
});

export const getAllServices = asyncHandler(async (req, res) => {
  const queryObj = { ...req.query };

  const excludeFields = ["page", "sort", "limit", ];
  excludeFields.forEach(el => delete queryObj[el]);


  let queryStr = JSON.stringify(queryObj);

  queryStr = queryStr.replace(/\b(gte|gt|lte|lt)\b/g, match => `$${match}`);

  // searching by name 

  let finalQuery = JSON.parse(queryStr);
  if ( req.query.search){
    finalQuery.serviceName = { $regex: req.query.search, $options: "i" };
  }
  const services = await Service.find(finalQuery);
  
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

  // Delete image from Supabase if it exists and is not a placeholder
  if (service.image && !service.image.includes("via.placeholder.com")) {
    try {
      const urlParts = service.image.split("/");
      const fileName = urlParts[urlParts.length - 1];
      
      const { error } = await superbase.storage
        .from(BUCKET_NAME)
        .remove([fileName]);

      if (error) {
        console.error("Supabase Image Deletion Error:", error.message);
      }
    } catch (err) {
      console.error("Error parsing image URL for deletion:", err);
    }
  }

  await service.deleteOne();
  res
    .status(200)
    .json({ success: true, message: "Service deleted successfully" });
});
