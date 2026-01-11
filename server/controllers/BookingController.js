import Booking from "../models/Booking.js";
import User from "../models/User.js";
import Service from "../models/Service.js";


export const createBooking = async (req, res) => {
  try {
    const { user, service, checkInDate, checkOutDate, status } = req.body;

    // 1. Validate user
    const existingUser = await User.findById(user);
    if (!existingUser) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    // 2. Validate service (Room/Office/Hall)
    const existingService = await Service.findById(service);
    if (!existingService) {
      return res
        .status(404)
        .json({ success: false, message: "Service not found" });
    }

    // 3. Validate and parse dates
    const checkIn = new Date(checkInDate);
    const checkOut = new Date(checkOutDate);

    if (checkOut <= checkIn) {
      return res.status(400).json({
        success: false,
        message: "Check-out date must be after check-in date",
      });
    }

    // 4. Calculate Total Price
    // Difference in milliseconds / (ms * sec * min * hours)
    const diffTime = Math.abs(checkOut - checkIn);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    const calculatedPrice = diffDays * existingService.price;

    // 5. Create booking
    const booking = await Booking.create({
      user,
      service,
      checkInDate: checkIn,
      checkOutDate: checkOut,
      totalPrice: calculatedPrice, // Now defined
      status: status || "confirmed",
    });

    // 6. Update service availability status
    existingService.isAvailable = false;
    await existingService.save();

    return res.status(201).json({
      success: true,
      message: "Booking created successfully",
      data: booking,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Server error while creating booking",
      error: error.message,
    });
  }
};


export const getAllBookings = async (req, res) => {
  try {
    const bookings = await Booking.find()
      .populate("user", "name email") // Matches your User model fields
      .populate("service", "serviceName price category"); // Matches Service model

    res.status(200).json({ success: true, count: bookings.length, data: bookings });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

export const getBookingById = async (req,res)=>{
  try {

    
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
} 


export const updateBooking = async (req, res) => {
  try {
    const { checkInDate, checkOutDate, status } = req.body;
    const booking = await Booking.findById(req.params.id).populate("service");

    if (!booking) {
      return res
        .status(404)
        .json({ success: false, message: "Booking not found" });
    }

    // Recalculate price if dates change
    if (checkInDate && checkOutDate) {
      const checkIn = new Date(checkInDate);
      const checkOut = new Date(checkOutDate);

      if (checkOut > checkIn) {
        const diffTime = Math.abs(checkOut - checkIn);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        booking.totalPrice = diffDays * booking.service.price;
        booking.checkInDate = checkIn;
        booking.checkOutDate = checkOut;
      }
    }

    if (status) booking.status = status;

    await booking.save();
    res.status(200).json({ success: true, message: "Updated", data: booking });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};


export const deleteBooking = async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);
    if (!booking) {
      return res
        .status(404)
        .json({ success: false, message: "Booking not found" });
    }

    // Mark the service as available again
    await Service.findByIdAndUpdate(booking.service, { isAvailable: true });

    await booking.deleteOne();
    res.status(200).json({ success: true, message: "Booking deleted" });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};
