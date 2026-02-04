import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _biometricEnabled = true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    const Color luxuryBlue = Color(0xFF001A72);
    const Color lightBlueBg = Color(0xFFE8EAF6);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          // Profile Image Section
          Center(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                      'https://img.freepik.com/premium-photo/profile-picture-happy-young-man-with-beard-blue-background-as-avatar-user-app-website_1250268-15494.jpg',
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: luxuryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // User Info
          Text(
            user?.name ?? "Guest User",
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? "guest@example.com",
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // Account Section
          const _SectionHeader(title: "ACCOUNT"),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _SettingTile(
                  icon: Icons.person_outline,
                  title: "Personal Information",
                  iconBgColor: lightBlueBg,
                  iconColor: luxuryBlue,
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _SettingTile(
                  icon: Icons.calendar_today_outlined,
                  title: "My Bookings",
                  iconBgColor: lightBlueBg,
                  iconColor: luxuryBlue,
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _SettingTile(
                  icon: Icons.payment_outlined,
                  title: "Payment Methods",
                  iconBgColor: lightBlueBg,
                  iconColor: luxuryBlue,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          // Preferences Section
          const _SectionHeader(title: "PREFERENCES"),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _SettingTile(
                  icon: Icons.fingerprint,
                  title: "Biometric Security",
                  iconBgColor: lightBlueBg,
                  iconColor: luxuryBlue,
                  trailing: Switch(
                    value: _biometricEnabled,
                    onChanged: (val) => setState(() => _biometricEnabled = val),
                    activeThumbColor: luxuryBlue,
                  ),
                ),
                const Divider(height: 1, indent: 56),
                _SettingTile(
                  icon: Icons.notifications_none,
                  title: "Notifications",
                  iconBgColor: lightBlueBg,
                  iconColor: luxuryBlue,
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _SettingTile(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  iconBgColor: lightBlueBg,
                  iconColor: luxuryBlue,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconBgColor;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.iconBgColor,
    required this.iconColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}
