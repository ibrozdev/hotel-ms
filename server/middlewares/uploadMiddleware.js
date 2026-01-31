import multer from "multer";

const storage = multer.memoryStorage(); // Waxba laguma kaydinayo computer-ka

const upload = multer({
  storage: storage,
  limits: { fileSize: 30 * 1024 * 1024 }, // 10MB limit (waa ku filan yahay)
  fieldSize: 50 * 1024 * 1024, // Ku dar tan si xogta qoraalka ahna loo oggolaado
});

export default upload;
