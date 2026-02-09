import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketDetailPage extends StatefulWidget {
  final String ticketCode;
  const TicketDetailPage({super.key, required this.ticketCode});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  Future<Map<String, dynamic>> fetchTicket() async {
    final supabase = Supabase.instance.client;

    final data = await supabase
        .from('tickets')
        .select()
        .eq('ticket_code', widget.ticketCode)
        .single();

    return data;
  }

  Future<void> completeService() async {
    final supabase = Supabase.instance.client;

    await supabase
        .from('tickets')
        .update({'status': 'completed'})
        .eq('ticket_code', widget.ticketCode);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: Text(widget.ticketCode),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: fetchTicket(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final ticket = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket['product_brand_model'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(ticket['product_type']),
                const SizedBox(height: 24),

                const Text(
                  'Issue Description',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(ticket['problem_description']),

                const Spacer(),

                if (ticket['status'] != 'completed')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: completeService,
                      icon: const Icon(Icons.check_circle),
                      label: const Text(
                        'Complete Service',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}