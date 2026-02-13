import 'package:chatbot/admin/create_staff_page.dart';
import 'package:chatbot/pages/staff/staff_gate.dart';
import 'package:chatbot/pages/staff/technician_fleet.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/supabase.dart';
import 'pages/customer/start_screen.dart';
import 'auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/',

      routes: {
        '/': (_) => const StartScreen(),
        '/login': (_) => const LoginPage(),
        '/staff': (_) => const StaffGate(),
        '/admin/create-staff': (_) => const CreateStaffPage(),
        '/technicians': (_) => const TechnicianFleetPage(serviceCenter: ''),
      },
    );
  }
}
