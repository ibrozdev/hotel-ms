import { body, validationResult } from "express-validator";

export const validate = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ success: false, errors: errors.array() });
  }
  next();
};

export const registerValidation = [
  body("name").notEmpty().withMessage("Magacu waa qasab"),
  body("email").isEmail().withMessage("Email sax ah geli"),
  body("password")
    .isLength({ min: 6 })
    .withMessage("Password-ku waa inuu ka yaraan 6 xaraf"),
  validate,
];

export const loginValidation = [
  body("email").isEmail().withMessage("Email sax ah geli"),
  body("password").notEmpty().withMessage("Password waa qasab"),
  validate,
];

export const bookingValidation = [
  body("service").isMongoId().withMessage("Invalid Service ID"),
  body("checkInDate").isISO8601().toDate().withMessage("Invalid Check-In Date"),
  body("checkOutDate").isISO8601().toDate().withMessage("Invalid Check-Out Date"),
  validate,
];
