import Service from "../models/service.js";


export const createService = async (req, res) => {
    try {

        const service = await Service.create(req.body);
        res.status(201).json({success:true,  message: "Service created successfully", data: service });
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};


export const getAllServices = async (req, res) => {
    try {
        const services = await Service.find();
        res.status(200).json({success:true, count:services.length, data: services});
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};


export const getServiceById = async (req, res) => {
    try {
        const service = await Service.findById(req.params.id);
        if (!service) {
            return res.status(404).json({ message: "Service not found" });
        }
        res.status(200).json(service);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};


export const updateService = async (req, res) => {
    try {
        const serviceId = req.params.id;
        if (!serviceId){
            return res.status(400).json({ message: "Service ID is required" });
        }
        const service = await Service.findByIdAndUpdate(
            serviceId,
            req.body,
            { new: true, runValidators: true }
        );

        if (!service) {
            return res.status(404).json({ message: "Service not found" });
        }

        res.status(200).json({success:true, data: service});
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};


export const deleteService = async (req, res) => {
    try {
        const service = await Service.findByIdAndDelete(req.params.id);

        if (!service) {
            return res.status(404).json({ message: "Service not found" });
        }

        res.status(200).json({ message: "Service deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
