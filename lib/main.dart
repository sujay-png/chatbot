import 'package:chatbot/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/supabase.dart';
import 'pages/customer/start_screen.dart';
import 'pages/staff/staff_dashboard.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

/// 🔐 CENTRAL AUTH ROUTER
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session;

        // ⏳ Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ Not logged in → Login
        if (session == null) {
          return const LoginPage();
        }

        // 🔐 Logged in → read metadata
        final userMeta = session.user.userMetadata ?? {};
        final role = userMeta['role'];
        final center = userMeta['service_center'];

        // ✅ Staff routing
        if (role == 'staff' && center != null) {
          return StaffDashboard(
            serviceCenter: center, // 🔥 pass center
          );
        }

        // 🧍 Default (customer or unknown)
        return const StartScreen();
      },
    );
  }
}