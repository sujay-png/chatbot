import 'package:chatbot/admin/create_staff_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StaffSidebar extends StatelessWidget {
  final bool isAdmin;
  final ValueChanged<String>? onSearchChanged;
  final String serviceCenter;

  const StaffSidebar({
    super.key,
    this.isAdmin = false,
    this.onSearchChanged,
    required this.serviceCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE6EBF2))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Staff Dashboard',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // 🔍 SEARCH
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search Ticket ID...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF1F3F7),
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
              color: Color(0xFF9AA4B2),
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text("Technician Fleet"),
            onTap: () {
              Navigator.pushNamed(context, '/technicians');
            },
          ),

          _navItem(
            icon: Icons.confirmation_number,
            label: 'All Tickets',
            active: true,
          ),

          // 🛡️ ADMIN ONLY
          if (isAdmin) ...[
            const SizedBox(height: 6),
            _navItem(
              icon: Icons.person_add_alt,
              label: 'Create Staff',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateStaffPage()),
                );
              },
            ),
          ],

          const Spacer(),
          const Divider(),

          // 🚪 LOGOUT
          ListTile(
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
              // AuthGate handles redirect
            },
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    bool active = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEFF4FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? const Color(0xFF2563EB) : Colors.grey),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: active
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
