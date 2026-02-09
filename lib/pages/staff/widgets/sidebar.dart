import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StaffSidebar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const StaffSidebar({
    super.key,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Color(0xFFE6EBF2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 TITLE
          const Text(
            'Staff Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // 🔍 SEARCH
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search tickets...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF1F3F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),

          const SizedBox(height: 32),

          // 🔹 NAV LABEL
          const Text(
            'NAVIGATION',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF9AA4B2),
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // 🔹 NAV CARD
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.confirmation_number,
                  color: Color(0xFF2563EB),
                ),
                SizedBox(width: 12),
                Text(
                  'All Tickets',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          const Divider(),

          // 🔴 LOGOUT
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              await Supabase.instance.client.auth.signOut();
              // AuthGate will redirect automatically
            },
          ),
        ],
      ),
    );
  }
}