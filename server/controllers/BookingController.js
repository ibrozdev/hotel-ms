import Booking from "../models/Booking.js";
import User from "../models/User.js";
import Service from "../models/service.js";
import asyncHandler from "express-async-handler";

// @desc Create New Booking
export const createBooking = asyncHandler(async (req, res) => {
  const { service, checkInDate, checkOutDate, paymentMethod } = req.body; // paymentMethod: 'Card' | 'PayAtHotel'

  // 1. Hubi in Service-ka uu jiro
  const existingService = await Service.findById(service);
  if (!existingService) {
    res.status(404);
    throw new Error("Adeeggan lama helin");
  }

  // 2. Hubi Taariikhda
  const checkIn = new Date(checkInDate);
  const checkOut = new Date(checkOutDate);
  
  if (isNaN(checkIn.getTime()) || isNaN(checkOut.getTime())) {
     res.status(400);
     throw new Error("Taariikhda la galiyay sax ma ahan");
  }

  if (checkOut <= checkIn) {
    res.status(400);
    throw new Error("Check-out waa inuu ka dambeeyaa Check-in");
  }

  // 3. Check Availability (Dynamic Date Range Check)
  // Find any confirmed booking for this service that overlaps with requested dates
  const conflictingBooking = await Booking.findOne({
    service: service,
    status: { $in: ["confirmed", "pending"] }, // Check confirmed or pending bookings
    $or: [
      {
        // Requested Start is between existing booking
        checkInDate: { $lt: checkOut },
        checkOutDate: { $gt: checkIn }
      }
    ]
  });

  if (conflictingBooking) {
    res.status(400);
    throw new Error("Waan ka xunnahay, waqtigan adeeggan waa la bandhigay (Booked). Fadlan dooro waqti kale.");
  }

  // 4. Xisaabi totalPrice
  const diffTime = Math.abs(checkOut - checkIn);
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  // Ensure at least 1 day charge even if same day checkout (hotel logic usually daily) 
  // or logic can differ if it's hourly. Assuming daily for now.
  const billingDays = diffDays === 0 ? 1 : diffDays; 
  const calculatedPrice = billingDays * existingService.price;

  // 5. Generate Unique Booking ID
  let bookingId;
  let isUnique = false;
  while (!isUnique) {
    bookingId = Math.floor(100000 + Math.random() * 900000).toString();
    const existingBooking = await Booking.findOne({ bookingId });
    if (!existingBooking) isUnique = true;
  }

  // 6. Payment Status Logic
  let bookingStatus = "confirmed";
  let paymentStatus = "Pending";

  if (paymentMethod === "PayAtHotel") {
      paymentStatus = "Pending";
  } else if (paymentMethod === "Card") {
      // Logic for "Simulated Card Payment"
      paymentStatus = "Paid";
  }

  // 7. Create Booking
  const booking = await Booking.create({
    user: req.user.id || req.user._id,
    service,
    bookingId: bookingId,
    checkInDate: checkIn,
    checkOutDate: checkOut,
    totalPrice: calculatedPrice,
    status: bookingStatus,
    paymentMethod,
    paymentStatus,
    // Add payment info if schema supports it, otherwise implied by status/method
    // For now we rely on status.
  });

  // Note: We DO NOT update Service.status to 'Booked' anymore.

  res
    .status(201)
    .json({ success: true, message: "Booking confirmed", data: booking });
});

// @desc Get All Bookings (Admin Only)
export const getAllBookings = asyncHandler(async (req, res) => {
  const bookings = await Booking.find()
    .populate("user", "name email phone")
    .populate("service", "serviceName price category");
  res.json({ success: true, count: bookings.length, data: bookings });
});

// @desc Get My Bookings (Logged In User)
export const getMyBookings = asyncHandler(async (req, res) => {
  const userId = req.user.id || req.user._id;
  const bookings = await Booking.find({ user: userId })
    .populate("service", "serviceName price category image")
    .sort("-createdAt");
    
  res.json(bookings); // Return array directly to match frontend expectation
});

// @desc Get Single Booking
export const getBookingById = asyncHandler(async (req, res) => {
  const booking = await Booking.findById(req.params.id)
    .populate("user", "name email")
    .populate("service");

  if (!booking) {
    res.status(404);
    throw new Error("Booking-kan lama helin");
  }

  // Helitaanka ID-yada si ammaan ah
  const bookingUserId =
    booking.user?._id?.toString() || booking.user?.toString();
  const currentUserId = req.user?.id?.toString() || req.user?._id?.toString();
  const isAdmin = req.user.role === "admin";

  // Haddii bookingUserId la waayo (user-kii waa la tirtiray), kaliya Admin baa arki kara
  if (!bookingUserId) {
    if (isAdmin) {
      return res.json({ success: true, data: booking });
    } else {
      res.status(403);
      throw new Error("Booking-kan ma lahan isticmaale ka diiwaangashan");
    }
  }

  const isOwner = bookingUserId === currentUserId;

  if (!isOwner && !isAdmin) {
    res.status(403);
    throw new Error("Ma oggolid inaad aragto booking-kan, adiga ma lihid");
  }

  res.json({ success: true, data: booking });
});

// @desc Delete/Cancel Booking
export const deleteBooking = asyncHandler(async (req, res) => {
  const booking = await Booking.findById(req.params.id);
  if (!booking) {
    res.status(404);
    throw new Error("Booking-kan lama helin");
  }

  // Qolka ka dhig mid banaan (Available)
  await Service.findByIdAndUpdate(booking.service, { status: "Available" });

  await booking.deleteOne();
  res.json({ success: true, message: "Booking cancelled and deleted" });
});

// @desc Update Booking (Admin Only)
export const updateBooking = asyncHandler(async (req, res) => {
  const { status, checkInDate, checkOutDate } = req.body;
  const booking = await Booking.findById(req.params.id);

  if (!booking) {
    res.status(404);
    throw new Error("Booking-kan lama helin");
  }

  // Update status if provided
  if (status) {
    booking.status = status;
    
    // If status is changed to cancelled, make the service available again
    if (status.toLowerCase() === "cancelled") {
      await Service.findByIdAndUpdate(booking.service, { status: "Available" });
    } else if (status.toLowerCase() === "confirmed" || status.toLowerCase() === "pending") {
      // If it's confirmed or pending, it should be marked as Booked to prevent others from booking it
      await Service.findByIdAndUpdate(booking.service, { status: "Booked" });
    }
  }

  // Update dates if provided
  if (checkInDate) booking.checkInDate = new Date(checkInDate);
  if (checkOutDate) booking.checkOutDate = new Date(checkOutDate);

  // Recalculate price if dates changed
  if (checkInDate || checkOutDate) {
    const existingService = await Service.findById(booking.service);
    if (existingService) {
      const checkIn = new Date(booking.checkInDate);
      const checkOut = new Date(booking.checkOutDate);
      if (checkOut > checkIn) {
        const diffTime = Math.abs(checkOut - checkIn);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        booking.totalPrice = diffDays * existingService.price;
      }
    }
  }

  const updatedBooking = await booking.save();
  res.json({ success: true, data: updatedBooking });
});

// @desc Get Revenue Stats
export const getRevenueStats = asyncHandler(async (req, res) => {
  const stats = await Booking.aggregate([
    { $match: { status: "confirmed" } },
    {
      $group: {
        _id: null,
        totalRevenue: { $sum: "$totalPrice" },
        totalBookings: { $sum: 1 },
        avgPrice: { $avg: "$totalPrice" },
      },
    },
  ]);

  res.status(200).json({
    success: true,
    data: stats.length > 0 ? stats[0] : { totalRevenue: 0, totalBookings: 0 },
  });
});
