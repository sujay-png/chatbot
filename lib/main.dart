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

      // ✅ initial screen
      initialRoute: '/',

      // ✅ named routes
      routes: {
        '/': (context) => const StartScreen(),
        '/staff': (context) => const StaffDashboard(),
      },
    );
  }
}