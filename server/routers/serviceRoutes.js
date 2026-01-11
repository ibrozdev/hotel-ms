import express from "express";
import {
    createService,
    getAllServices,
    getServiceById,
    updateService,
    deleteService
} from "../controllers/serviceController.js";

const router = express.Router();

router.post("/create", createService);
router.get("/getservice", getAllServices);
router.get("/getservice/:id", getServiceById);
router.put("/update/:id", updateService);
router.delete("/delete/:id", deleteService);

export default router;
