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

    await fetchTicket();
  }

  Widget chip(String text, Color bg, Color fg) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget statusChip(String s) =>
      s == 'completed'
          ? chip('COMPLETED', const Color(0xFFDCFCE7), const Color(0xFF166534))
          : chip('OPEN', const Color(0xFFFFF3D6), const Color(0xFFB45309));

  Widget paymentChip(String s) =>
      s == 'paid'
          ? chip('PAID', const Color(0xFFDCFCE7), const Color(0xFF166534))
          : chip('UNPAID', const Color(0xFFFCE4E4), const Color(0xFFB91C1C));

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Row(
        children: [
          StaffSidebar(onSearchChanged: (String value) {  },),

          Expanded(
            child: Column(
              children: [
                // 🔹 HEADER (FIXED)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        ticket!['ticket_code'],
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
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
                          label: const Text('Complete Service',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E9D62),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),

                      const SizedBox(width: 12),

                      if (ticket!['payment_status'] == 'unpaid')
                        ElevatedButton.icon(
                          onPressed: () async {
                            final paid = await showDialog<bool>(
                              context: context,
                              builder: (_) => PaymentModal(ticketId: ticket!['ticket_code']),
                            );
                            if (paid == true) await fetchTicket();
                          },
                          icon: const Icon(Icons.credit_card, color: Colors.white),
                          label: const Text('Process Payment',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B6EF6),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                    ],
                  ),
                ),

                // 🔹 MAIN CONTENT (THIS WAS MISSING)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sectionTitle('PRODUCT DETAILS'),
                              rowCards(
                                infoCard('Product Type', ticket!['product_type']),
                                infoCard('Brand & Model', ticket!['product_brand_model']),
                              ),
                              sectionTitle('ISSUE DESCRIPTION'),
                              whiteCard(Text('"${ticket!['problem_description']}"',
                                  style: const TextStyle(fontStyle: FontStyle.italic))),
                              sectionTitle('ATTACHMENTS'),
                              attachmentBox(),
                            ],
                          ),
                        ),

                        const SizedBox(width: 32),

                        // RIGHT
                        Expanded(
                          flex: 2,
                          child: customerCard(
                            ticket!['customer_name'],
                            ticket!['customer_phone'],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- UI HELPERS ----------

  Widget sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 32),
        child: Text(t,
            style: const TextStyle(
                color: Colors.grey, letterSpacing: 1, fontWeight: FontWeight.bold)),
      );

  Widget rowCards(Widget a, Widget b) => Row(
        children: [Expanded(child: a), const SizedBox(width: 16), Expanded(child: b)],
      );

  Widget infoCard(String label, String value) =>
      whiteCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ]));

  Widget whiteCard(Widget child) => Container(
        padding: const EdgeInsets.all(20),
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: child,
      );

  Widget attachmentBox() => Container(
        width: 180,
        height: 180,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Center(
          child: Text('No images uploaded', style: TextStyle(color: Colors.grey)),
        ),
      );

  Widget customerCard(String? name, String? phone) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF020617)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Customer Contact',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(name ?? 'Unknown',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(phone ?? '', style: const TextStyle(color: Colors.white70)),
        ]),
      );
}