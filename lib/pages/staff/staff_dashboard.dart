import 'package:chatbot/pages/staff/widgets/ticket_table.dart';
import 'package:flutter/material.dart';
import 'widgets/sidebar.dart';


class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Row(
        children: const [
          StaffSidebar(),
          Expanded(child: TicketListPage()),
        ],
      ),
    );
  }
}