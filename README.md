# LuxeSpace - Hotel Management System

A comprehensive Hotel Management System built with a modern **Flutter** frontend and a robust **Node.js/Express** backend. The application allows users to browse hotel services, make bookings, and manage their reservations, while providing administrators with tools to manage services and view booking statistics.

## 🚀 Tech Stack

### Backend
- **Framework**: Node.js & Express.js
- **Database**: MongoDB (with Mongoose)
- **Authentication**: JWT (JSON Web Tokens)
- **Security**: Helmet, Rate Limiting, Mongo Sanitize
- **Validation**: Express-Validator

### Frontend
- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Networking**: Dio
- **Storage**: Flutter Secure Storage
- **UI**: Google Fonts, Cached Network Image, Custom "Luxury" Design System

---

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed:
- **Node.js** (v14 or higher) & **npm**
- **Flutter SDK** (Latest Stable)`
- **MongoDB** (Local instance or MongoDB Atlas Connection String)

---

## 📦 Installation & Setup

Clone the repository:
```bash
git clone https://github.com/yourusername/hotel-ms.git
cd hotel-ms
```

### 1. Backend Setup

Navigate to the server directory and install dependencies:
```bash
cd server
npm install
```

**Configuration:**
Create a `.env` file in the `server` directory with the following variables:
```env
PORT=5000
MONGO_URI=mongodb://localhost:27017/hotel_ms_db  # Or your MongoDB Atlas URI
JWT_SECRET=your_super_secret_jwt_key
```

**Run the Server:**
```bash
# Development mode (restarts on changes)
npm run dev

# Production start
npm start
```
*The server will start on `http://localhost:5000`*

### 2. Frontend Setup

Navigate to the clients directory and install dependencies:
```bash
cd ../clients
flutter pub get
```

**Configuration (Important for Mobile Testing):**
If you are running on a physical device or emulator, you may need to update the API base URL.
Open `lib/core/network/api_constants.dart` and update the IP address:
```dart
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }
    // Update this to your computer's local IP address
    return 'http://YOUR_LOCAL_IP:5000/api'; 
  }
```

**Run the App:**
```bash
# Run on connected device
flutter run
```

---

## 📱 Features

- **Authentication**: Secure Login & Registration with specific error handling.
- **Service Browsing**: Explore hotel rooms, halls, and office spaces with rich images and details.
- **Booking System**: 
  - Interactive Date Picker.
  - "Pay at Hotel" or "Card" (simulated) payment options.
  - Unique Booking ID & QR Code generation.
  - **Rate Limiting Protection**: Backend protects against spam requests.
- **User Dashboard**: View upcoming stays and booking history.
- **Admin Dashboard**: Manage services, view revenue, and booking analytics.

## 📂 Project Structure

```
hotel-ms/
├── server/                 # Backend Node.js API
│   ├── config/             # DB Connection
│   ├── controllers/        # Route Logic
│   ├── middlewares/        # Auth, RateLimit, ErrorHandling
│   ├── models/             # Mongoose Schemas
│   └── routers/            # API Endpoints
│
└── clients/                # Frontend Flutter App
    ├── lib/
    │   ├── core/           # Constants, Network Client
    │   ├── features/       # Auth, Booking, Customer, Admin modules
    │   ├── models/         # Data Models
    │   └── services/       # Logic Providers
    └── pubspec.yaml        # Dependencies
```

## 🤝 Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
