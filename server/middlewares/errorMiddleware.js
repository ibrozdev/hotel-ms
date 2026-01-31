// Hubi inay 4-tuba ku jiraan: err, req, res, next
export const errorHandler = (err, req, res, next) => {
  const statusCode =
    res && res.statusCode
      ? res.statusCode === 200
        ? 500
        : res.statusCode
      : 500;

  res.status(statusCode).json({
    success: false,
    message: err.message || "Server Error",
    stack: process.env.NODE_ENV === "production" ? null : err.stack,
  });
};
