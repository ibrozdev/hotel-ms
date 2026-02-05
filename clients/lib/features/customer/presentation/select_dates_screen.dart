import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../models/service_model.dart';
import '../../../../core/network/api_constants.dart';
import '../../booking/booking_provider.dart';
import '../../auth/auth_provider.dart';
import '../../booking/presentation/booking_confirmation_screen.dart';

class SelectDatesScreen extends StatefulWidget {
  final HotelService service;

  const SelectDatesScreen({super.key, required this.service});

  @override
  State<SelectDatesScreen> createState() => _SelectDatesScreenState();
}

class _SelectDatesScreenState extends State<SelectDatesScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  static const Color luxuryBlue = Color(0xFF00008B);

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;

    int nights = 0;
    if (_rangeStart != null && _rangeEnd != null) {
      nights = _rangeEnd!.difference(_rangeStart!).inDays;
    }
    double totalPrice = nights * widget.service.price;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Select Dates",
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServiceSummary(),
                  const SizedBox(height: 32),
                  _buildCalendar(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(
        bookingProvider,
        user,
        nights,
        totalPrice,
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: luxuryBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
                ? CachedNetworkImage(
                    imageUrl: widget.service.image!.startsWith('http')
                        ? widget.service.image!
                        : '${ApiConstants.imageBaseUrl}${widget.service.image}',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  )
                : Container(color: Colors.grey.shade200, width: 70, height: 70),
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
                    fontSize: 16,
                    color: const Color(0xFF001A72),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${widget.service.price.toInt()} / night • ${widget.service.maxCapacity} Guests",
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        rangeSelectionMode: RangeSelectionMode.enforced,
        onRangeSelected: (start, end, focusedDay) {
          setState(() {
            _rangeStart = start;
            _rangeEnd = end;
            _focusedDay = focusedDay;
          });
        },
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: false,
          titleTextStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: Colors.black87,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: Colors.black87,
          ),
        ),
        calendarStyle: CalendarStyle(
          rangeHighlightColor: luxuryBlue.withOpacity(0.1),
          rangeStartDecoration: const BoxDecoration(
            color: luxuryBlue,
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: const BoxDecoration(
            color: luxuryBlue,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: luxuryBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: luxuryBlue,
            fontWeight: FontWeight.bold,
          ),
          selectedTextStyle: const TextStyle(color: Colors.white),
          withinRangeTextStyle: const TextStyle(color: luxuryBlue),
          defaultTextStyle: GoogleFonts.inter(),
          weekendTextStyle: GoogleFonts.inter(color: Colors.red.shade300),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.inter(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          weekendStyle: GoogleFonts.inter(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BookingProvider provider,
    dynamic user,
    int nights,
    double totalPrice,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\$${totalPrice.toInt()}",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF001A72),
                      ),
                    ),
                    TextSpan(
                      text: " Total",
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (nights > 0)
                Text(
                  "$nights Nights",
                  style: GoogleFonts.inter(
                    color: luxuryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: (nights == 0 || provider.isLoading)
                    ? null
                    : () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingConfirmationScreen(
                              service: widget.service,
                              checkIn: _rangeStart!,
                              checkOut: _rangeEnd!,
                              nights: nights,
                              totalPrice: totalPrice,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: luxuryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: provider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Continue",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
