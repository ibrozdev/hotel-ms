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

  if (!existingService.isAvailable) {
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

  // 4. Create Booking (User-ka waxaa laga qaadayaa req.user oo ah qofka login-ka ah)
  const booking = await Booking.create({
    user: req.user._id,
    service,
    checkInDate: checkIn,
    checkOutDate: checkOut,
    totalPrice: calculatedPrice,
    status: status || "confirmed",
  });

  // 5. Update Service Availability
  existingService.isAvailable = false;
  await existingService.save();

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
  const currentUserId = req.user?._id?.toString();
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
  await Service.findByIdAndUpdate(booking.service, { isAvailable: true });

  await booking.deleteOne();
  res.json({ success: true, message: "Booking cancelled and deleted" });
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
