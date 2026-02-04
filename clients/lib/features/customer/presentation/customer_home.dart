import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/network/api_constants.dart';
import '../../auth/auth_provider.dart';
import '../../services/service_provider.dart';
import '../../booking/booking_provider.dart';
import '../../auth/presentation/login_screen.dart';
import 'service_details.dart';
import 'my_bookings.dart';
import 'profile_screen.dart';
import 'customer_dashboard.dart';
import 'search_results_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  int _bottomNavIndex = 0;
  bool _isFirstCheck = true;
  String? _previousUserId;

  final List<String> _filters = ["All", "Dates", "Price", "Amenities"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false).fetchServices();
      Provider.of<BookingProvider>(context, listen: false).fetchMyBookings();
    });
  }

  String _getTitle() {
    switch (_bottomNavIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Explore Services';
      case 2:
        return 'My Bookings';
      case 3:
        return 'My Profile';
      default:
        return 'Home';
    }
  }

  Widget _buildLoginPrompt(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: GoogleFonts.inter(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF001A72),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Login Now',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBody(AuthProvider authProvider) {
    switch (_bottomNavIndex) {
      case 0:
        if (authProvider.currentUser == null) {
          return _buildLoginPrompt(
            context,
            'Fadlan login sameey si aad u aragto dashboard-kaaga.',
          );
        }
        return const CustomerDashboard();
      case 1:
        return _ExploreBody(
          searchController: _searchController,
          filters: _filters,
          selectedFilterIndex: _selectedFilterIndex,
          onFilterSelected: (index) =>
              setState(() => _selectedFilterIndex = index),
        );
      case 2:
        if (authProvider.currentUser == null) {
          return _buildLoginPrompt(
            context,
            'Fadlan login sameey si aad u aragto dhexasashadaada.',
          );
        }
        return MyBookingsScreen();
      case 3:
        return const ProfileScreen();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color luxuryBlue = Color(0xFF001A72);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    // Handle initial tab for guests and redirection after login
    if (_isFirstCheck) {
      if (user == null) {
        _bottomNavIndex = 1; // Default to Explore for guests
      }
      _previousUserId = user?.id;
      _isFirstCheck = false;
    } else if (user != null && _previousUserId == null) {
      // User just logged in
      _bottomNavIndex = 0; // Switch to Dashboard
      _previousUserId = user.id;
    } else if (user == null && _previousUserId != null) {
      // User just logged out
      _bottomNavIndex = 1;
      _previousUserId = null;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 150,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: luxuryBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.business,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "LuxeSpace",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: luxuryBlue,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        title: Text(
          _getTitle(),
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          if (user == null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                icon: const Icon(Icons.login, color: luxuryBlue, size: 20),
                label: const Text(
                  'Login',
                  style: TextStyle(
                    color: luxuryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton.icon(
                onPressed: () => authProvider.logout(),
                icon: const Icon(Icons.logout, color: luxuryBlue, size: 20),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: luxuryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _getBody(authProvider),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: luxuryBlue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online_outlined),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _ExploreBody extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> filters;
  final int selectedFilterIndex;
  final Function(int) onFilterSelected;

  const _ExploreBody({
    required this.searchController,
    required this.filters,
    required this.selectedFilterIndex,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    const Color luxuryBlue = Color(0xFF001A72);

    return Consumer<ServiceProvider>(
      builder: (context, provider, child) {
        final user = Provider.of<AuthProvider>(context).currentUser;
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Section
              _buildHeroSection(context, luxuryBlue),

              // 2. Explore Categories
              _buildSectionHeader("Explore Categories", null),
              _buildCategorySection(),

              // 3. Top Rated Destinations
              _buildSectionHeader("Top Rated Destinations", "See all"),
              _buildDestinationsSection(context, provider.services),

              // 4. Join LuxeSpace CTA (Only for guests)
              if (user == null) _buildCTASection(context, luxuryBlue),

              // 5. Footer
              _buildFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroSection(BuildContext context, Color luxuryBlue) {
    return Stack(
      children: [
        // Background Hero Image
        Container(
          height: 400,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Dark Overlay for better contrast
        Container(
          height: 400,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.1),
              ],
            ),
          ),
        ),
        // Search Card
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 160, 20, 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Find your perfect space",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // Search Fields
                _buildSearchInput(
                  Icons.location_on,
                  "Location",
                  Colors.indigo[900]!,
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildSearchInput(
                        Icons.calendar_month,
                        "Date",
                        Colors.indigo[900]!,
                      ),
                    ),
                    Container(width: 1, height: 40, color: Colors.grey[200]),
                    Expanded(
                      child: _buildSearchInput(
                        Icons.business_center,
                        "Service",
                        Colors.indigo[900]!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Search Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchResultsScreen(
                            initialSearch: searchController.text,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search, color: Colors.white),
                    label: Text(
                      "Search LuxeSpace",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: luxuryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchInput(IconData icon, String label, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String? actionLabel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (actionLabel != null)
            Text(
              actionLabel,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.indigo[900],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildCategoryCard(
            "Room",
            "https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&q=80",
          ),
          _buildCategoryCard(
            "Hall",
            "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&q=80",
          ),
          _buildCategoryCard(
            "Office",
            "https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80",
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String label, String imageUrl) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchResultsScreen(initialCategory: label),
            ),
          );
        },
        child: Container(
          width: 140,
          height: 100,
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: CachedNetworkImageProvider(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(12),
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationsSection(BuildContext context, List services) {
    return SizedBox(
      height: 380,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: services.take(5).length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _DestinationCard(service: service);
        },
      ),
    );
  }

  Widget _buildCTASection(BuildContext context, Color luxuryBlue) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF001A72),
              const Color(0xFF001A72).withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Text(
              "Join LuxeSpace",
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Unlock exclusive member rates, earn loyalty points, and experience seamless booking.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: luxuryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Sign Up Now",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Already have an account? ",
                      style: GoogleFonts.inter(color: Colors.white70),
                    ),
                    TextSpan(
                      text: "Sign In",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: const Color(0xFFF1F4F8),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.business, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "LuxeSpace",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterTitle("Discover"),
                    _FooterLink("Room & Suites"),
                    _FooterLink("Meeting Hall"),
                    _FooterLink("Office Space"),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterTitle("Support"),
                    _FooterLink("Help Center"),
                    _FooterLink("Trust & Safety"),
                    _FooterLink("Privacy Policy"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              "© 2024 LuxeSpace International. All rights reserved.",
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _FooterTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _FooterLink(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final dynamic service;

  const _DestinationCard({required this.service});

  @override
  Widget build(BuildContext context) {
    const Color luxuryBlue = Color(0xFF001A72);

    return Container(
      width: 280,
      margin: const EdgeInsets.only(left: 12, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      service.image != null && service.image!.startsWith('http')
                      ? service.image!
                      : '${ApiConstants.imageBaseUrl}${service.image}',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(height: 180, color: Colors.grey[200]),
                  errorWidget: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "4.9",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        service.serviceName,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "\$${service.price.toStringAsFixed(0)}/nt",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00AA6C),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      "Canary Wharf, London", // Placeholder
                      style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ServiceDetailsScreen(service: service),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: luxuryBlue.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "View Details",
                      style: GoogleFonts.inter(
                        color: luxuryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
