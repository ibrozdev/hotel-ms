import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../models/service_model.dart';
import '../../auth/auth_provider.dart';
import '../booking_provider.dart';
import '../../customer/presentation/booking_success_screen.dart';
import '../../../../core/network/api_constants.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final HotelService service;
  final DateTime checkIn;
  final DateTime checkOut;
  final int nights;
  final double totalPrice;

  const BookingConfirmationScreen({
    super.key,
    required this.service,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.totalPrice,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  String _selectedPaymentMethod = 'PayAtHotel';
  final Color luxuryBlue = const Color(0xFF00008B);

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final user = Provider.of<AuthProvider>(context).currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("User not found")));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "Confirm Booking",
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceCard(),
            const SizedBox(height: 24),
            _buildBookingDetails(),
            const SizedBox(height: 24),
            _buildPaymentMethodSection(),
            const SizedBox(height: 24),
            _buildPriceBreakdown(),
            const SizedBox(height: 32),
            _buildConfirmButton(bookingProvider, user),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: widget.service.image != null
                ? Image.network(
                    widget.service.image!.startsWith('http')
                        ? widget.service.image!
                        : '${ApiConstants.imageBaseUrl}${widget.service.image}',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      width: 80,
                      height: 80,
                    ),
                  )
                : Container(color: Colors.grey.shade200, width: 80, height: 80),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.serviceName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color(0xFF001A72),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.service.category,
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Booking Details",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(height: 24),
          _buildDetailRow("Check-in", dateFormat.format(widget.checkIn)),
          const SizedBox(height: 12),
          _buildDetailRow("Check-out", dateFormat.format(widget.checkOut)),
          const SizedBox(height: 12),
          _buildDetailRow("Duration", "${widget.nights} Nights"),
          const SizedBox(height: 12),
          _buildDetailRow(
            "Guests",
            "${widget.service.maxCapacity} Guests (Max)",
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 14),
        ),
        Text(
          value,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Method",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                value: 'PayAtHotel',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
                title: Text(
                  "Pay at Hotel",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "Pay when you check-in",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                secondary: const Icon(
                  Icons.storefront_outlined,
                  color: Colors.green,
                ),
                activeColor: luxuryBlue,
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                value: 'Card',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
                title: Text(
                  "Credit/Debit Card",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "Instant payment (Simulated)",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                secondary: const Icon(
                  Icons.credit_card_outlined,
                  color: Colors.blue,
                ),
                activeColor: luxuryBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(
            "\$${widget.service.price.toInt()} x ${widget.nights} nights",
            "\$${widget.totalPrice.toInt()}",
          ),
          const SizedBox(height: 12),
          _buildDetailRow("Taxes & Fees", "\$0"), // Simplified
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                "\$${widget.totalPrice.toInt()}",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: luxuryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BookingProvider provider, dynamic user) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: provider.isLoading
            ? null
            : () async {
                final error = await provider.createBooking(
                  user.id,
                  widget.service.id,
                  widget.checkIn,
                  widget.checkOut,
                  _selectedPaymentMethod,
                );

                if (mounted) {
                  if (error == null) {
                    await provider.fetchMyBookings();
                    if (provider.myBookings.isNotEmpty) {
                      final newBooking = provider.myBookings.first;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BookingSuccessScreen(booking: newBooking),
                        ),
                        (route) => route.isFirst,
                      );
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Booking created but could not fetch details.',
                          ),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Booking failed: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: luxuryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: provider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                "Confirm & Pay",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
