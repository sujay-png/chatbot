import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TechnicianDashboard extends StatefulWidget {
  const TechnicianDashboard({super.key});

  @override
  State<TechnicianDashboard> createState() =>
      _TechnicianDashboardState();
}

class _TechnicianDashboardState
    extends State<TechnicianDashboard> {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> fetchMyTickets() async {
    final user = supabase.auth.currentUser;

    return await supabase
        .from('tickets')
        .select()
        .eq('technician_id', user!.id)
        .order('created_at', ascending: false);
  }

Future<List> fetchAssignedTickets() async {
  final user = Supabase.instance.client.auth.currentUser;
  final techId = user?.id;

  return await Supabase.instance.client
      .from('tickets')
      .select()
      .eq('technician_id', techId as Object);
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchMyTickets(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tickets = snapshot.data as List;

        return ListView.builder(
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final t = tickets[index];

            return ListTile(
              title: Text(t['ticket_code']),
              subtitle: Text(t['product_brand_model']),
              trailing: ElevatedButton(
                onPressed: () async {
                  await supabase
                      .from('tickets')
                      .update({'status': 'completed'})
                      .eq('id', t['id']);

                  setState(() {});
                },
                child: const Text("Mark Completed"),
              ),
            );
          },
        );
      },
    );
  }
}