import 'package:flutter/material.dart';

class StaffSidebar extends StatelessWidget {
  const StaffSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Staff Dashboard',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          TextField(
            decoration: InputDecoration(
              hintText: 'Search Ticket ID...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF1F3F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 32),

          const Text(
            'NAVIGATION',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: const [
                Icon(Icons.confirmation_number, color: Color(0xFF3B6EF6)),
                SizedBox(width: 12),
                Text(
                  'All Tickets',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B6EF6),
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