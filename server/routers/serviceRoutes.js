import express from "express";
import {
  createService,
  getAllServices,
  getServiceById,
  updateService,
  deleteService,
} from "../controllers/serviceController.js";
import { protect, authorize } from "../middlewares/authMiddleware.js";

const router = express.Router();

// Routes-ka la xiray (Protected & Admin Only)
router.post("/create", protect, authorize("admin"), createService);
router.put("/update/:id", protect, authorize("admin"), updateService);
router.delete("/delete/:id", protect, authorize("admin"), deleteService);

// Routes-ka furan (Qof walba waa arki karaa laakiin waa inuu login yahay si uu u helo liiska)
router.get("/getservice", protect, getAllServices);
router.get("/getservice/:id", protect, getServiceById);

export default router;
