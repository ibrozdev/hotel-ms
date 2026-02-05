import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../models/booking_model.dart';
import 'customer_home.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Booking booking;

  const BookingSuccessScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    const Color luxuryBlue = Color(0xFF00008B);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildSuccessIcon(),
              const SizedBox(height: 32),
              Text(
                "Payment Successful!",
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Your booking has been confirmed. A confirmation email has been sent to your inbox.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              _buildTicketCard(luxuryBlue),
              const Spacer(),
              _buildActionButtons(context, luxuryBlue),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 10,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 80),
      ),
    );
  }

  Widget _buildTicketCard(Color luxuryBlue) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "BOOKING ID #${booking.bookingId}",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: luxuryBlue,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          QrImageView(
            data: booking.id,
            version: QrVersions.auto,
            size: 180.0,
            gapless: false,
          ),
          const SizedBox(height: 24),
          Text(
            "Scan this code at the reception kiosk\nfor express check-in.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Color luxuryBlue) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const CustomerHomeScreen(initialIndex: 2),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: luxuryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              "View Booking Details",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const CustomerHomeScreen(initialIndex: 0),
                ),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF5F6FA),
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "Go to Home",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
