import Booking from "../models/Booking.js";
import User from "../models/User.js";
import Service from "../models/service.js";
import asyncHandler from "express-async-handler";

// @desc Create New Booking
export const createBooking = asyncHandler(async (req, res) => {
  const { service, checkInDate, checkOutDate, status } = req.body;

  // 1. Hubi in Service-ka uu jiro iyo inuu banaan yahay
  const existingService = await Service.findById(service);
  if (!existingService) {
    res.status(404);
    throw new Error("Adeeggan lama helin");
  }

  if (existingService.status !== "Available") {
    res.status(400);
    throw new Error("Adeeggan (Qolka/Hoolka) horay ayaa loo qabsaday!");
  }

  // 2. Hubi Taariikhda
  const checkIn = new Date(checkInDate);
  const checkOut = new Date(checkOutDate);
  if (checkOut <= checkIn) {
    res.status(400);
    throw new Error("Check-out waa inuu ka dambeeyaa Check-in");
  }

  // 3. Xisaabi totalPrice
  const diffTime = Math.abs(checkOut - checkIn);
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  const calculatedPrice = diffDays * existingService.price;

  // 4. Generate Unique Booking ID
  let bookingId;
  let isUnique = false;
  while (!isUnique) {
    bookingId = Math.floor(100000 + Math.random() * 900000).toString();
    const existingBooking = await Booking.findOne({ bookingId });
    if (!existingBooking) isUnique = true;
  }

  // 5. Create Booking (User-ka waxaa laga qaadayaa req.user oo ah qofka login-ka ah)
  const booking = await Booking.create({
    user: req.user.id || req.user._id, // Support both
    service,
    bookingId: bookingId,
    checkInDate: checkIn,
    checkOutDate: checkOut,
    totalPrice: calculatedPrice,
    status: status || "confirmed",
  });

  // 5. Update Service Status
  await Service.findByIdAndUpdate(service, { status: "Booked" });

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
