import 'package:chatbot/auth/login_page.dart';
import 'package:chatbot/pages/customer/start_screen.dart';
import 'package:chatbot/pages/staff/staff_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class StaffGate extends StatefulWidget {
  const StaffGate({super.key});

  @override
  State<StaffGate> createState() => _StaffGateState();
}

class _StaffGateState extends State<StaffGate> {
  Session? _session;

  @override
  void initState() {
    super.initState();
    _session = Supabase.instance.client.auth.currentSession;

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      setState(() {
        _session = data.session;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ⏳ Loading state
    if (_session == null) {
      return const LoginPage();
    }

    final user = _session!.user;
    final meta = user.userMetadata ?? {};

    final role = meta['role'];
    final center = meta['service_center'];

    // 👑 ADMIN
    if (role == 'admin') {
      return const StaffDashboard(
        isAdmin: true,
        serviceCenter: '',
      );
    }

    // 👷 STAFF
    if (role == 'staff' && center != null) {
      return StaffDashboard(
        serviceCenter: center,
      );
    }

    // 🧍 CUSTOMER / FALLBACK
    return const StartScreen();
  }
}