import 'package:flutter/material.dart';
import 'widgets/sidebar.dart';
import 'widgets/status_filter.dart';
import 'widgets/ticket_table.dart';

class StaffDashboard extends StatefulWidget {
  final String serviceCenter;

  const StaffDashboard({super.key, required this.serviceCenter});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  String statusFilter = 'all';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Row(
        children: [
          StaffSidebar(
  onSearchChanged: (value) {
    setState(() => searchQuery = value);
  },
),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Center: ${widget.serviceCenter.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'All Service Tickets',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Manage and track all customer service requests.',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  StatusFilter(
                    selected: statusFilter,
                    onChanged: (value) {
                      setState(() => statusFilter = value);
                    },
                  ),

                  const SizedBox(height: 24),

                  Expanded(child: TicketTable(filter: statusFilter, search: '',)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
