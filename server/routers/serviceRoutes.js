import express from "express";
import {
  createService,
  getAllServices,
  getServiceById,
  updateService,
  deleteService,
} from "../controllers/serviceController.js";
import { protect, authorize } from "../middlewares/authMiddleware.js";
import upload from "../middlewares/uploadMiddleware.js";

const router = express.Router();

// Routes-ka la xiray (Protected & Admin Only)
router.post(
  "/create",
  protect,
  authorize("admin"),
  upload.single("image"),
  createService,
);
router.put("/update/:id", protect, authorize("admin"), updateService);
router.delete("/delete/:id", protect, authorize("admin"), deleteService);

// Routes-ka furan (Qof walba waa arki karaa - No authentication required)
router.get("/getservice", getAllServices);
router.get("/getservice/:id", getServiceById);

export default router;
