import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/admin/presentation/admin_dashboard.dart';
import 'features/auth/auth_provider.dart';
import 'features/customer/presentation/customer_home.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;

    if (user?.role == 'admin') {
      return const AdminDashboard();
    } else {
      return CustomerHomeScreen(key: ValueKey(user?.id ?? 'guest'));
    }
  }
}
