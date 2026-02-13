import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TechnicianFleetPage extends StatefulWidget {
  const TechnicianFleetPage({super.key, required String serviceCenter});

  @override
  State<TechnicianFleetPage> createState() =>
      _TechnicianFleetPageState();
}

class _TechnicianFleetPageState
    extends State<TechnicianFleetPage> {

  final supabase = Supabase.instance.client;

  Future<List<dynamic>> fetchTechnicians() async {
    return await supabase
        .from('technicians')
        .select()
        .order('created_at', ascending: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Technician Fleet"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: fetchTechnicians(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final techs = snapshot.data as List;

          if (techs.isEmpty) {
            return const Center(
              child: Text("No technicians found"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: techs.length,
            itemBuilder: (context, index) {
              final t = techs[index];

              return Card(
                child: ListTile(
                  title: Text(t['full_name']),
                  subtitle: Text(
                      "${t['department']} • ${t['service_center']}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}