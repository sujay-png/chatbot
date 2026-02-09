import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/sidebar.dart';
import 'payment_modal.dart';

class TicketDetailPage extends StatefulWidget {
  final String ticketCode;
  const TicketDetailPage({super.key, required this.ticketCode});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? ticket;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchTicket();
  }

  Future<void> fetchTicket() async {
    final data = await supabase
        .from('tickets')
        .select()
        .eq('ticket_code', widget.ticketCode)
        .single();

    setState(() {
      ticket = data;
      loading = false;
    });
  }

  Future<void> completeService() async {
    await supabase
        .from('tickets')
        .update({'status': 'completed'})
        .eq('ticket_code', widget.ticketCode);

    await fetchTicket(); // ✅ REFRESH
  }

  // 🔹 Animated chip
  Widget chip(String text, Color bg, Color fg) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget statusChip(String status) {
    if (status == 'completed') {
      return chip('COMPLETED', const Color(0xFFDCFCE7), const Color(0xFF166534));
    }
    return chip('OPEN', const Color(0xFFFFF3D6), const Color(0xFFB45309));
  }

  Widget paymentChip(String status) {
    if (status == 'paid') {
      return chip('PAID', const Color(0xFFDCFCE7), const Color(0xFF166534));
    }
    return chip('UNPAID', const Color(0xFFFCE4E4), const Color(0xFFB91C1C));
  }

  @override
  Widget build(BuildContext context) {
    if (loading || ticket == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Row(
        children: [
          const StaffSidebar(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 HEADER
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        ticket!['ticket_code'],
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      statusChip(ticket!['status']),
                      const SizedBox(width: 8),
                      paymentChip(ticket!['payment_status']),
                      const Spacer(),

                      if (ticket!['status'] != 'completed')
                        ElevatedButton.icon(
                          onPressed: completeService,
                          icon: const Icon(Icons.check_circle, color: Colors.white),
                          label: const Text(
                            'Complete Service',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E9D62),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),

                      const SizedBox(width: 12),

                      if (ticket!['payment_status'] == 'unpaid')
                        ElevatedButton.icon(
                          onPressed: () async {
                            final paid = await showDialog<bool>(
                              context: context,
                              builder: (_) => PaymentModal(
                                ticketId: ticket!['ticket_code'],
                              ),
                            );

                            if (paid == true) {
                              await fetchTicket(); // ✅ THIS WAS MISSING
                            }
                          },
                          icon: const Icon(Icons.credit_card, color: Colors.white),
                          label: const Text(
                            'Process Payment',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B6EF6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}