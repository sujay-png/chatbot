import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'payment_modal.dart';

class TicketDetailPage extends StatefulWidget {
  final String ticketCode;
  const TicketDetailPage({super.key, required this.ticketCode});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  Future<Map<String, dynamic>> fetchTicket() async {
    final supabase = Supabase.instance.client;
    return await supabase
        .from('tickets')
        .select()
        .eq('ticket_code', widget.ticketCode)
        .single();
  }

  Future<void> completeService() async {
    final supabase = Supabase.instance.client;

    await supabase
        .from('tickets')
        .update({'status': 'completed'})
        .eq('ticket_code', widget.ticketCode);

    setState(() {});
  }

  Widget _chip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: FutureBuilder(
        future: fetchTicket(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final ticket = snapshot.data!;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(24),
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
                        const SizedBox(width: 8),
                        Text(
                          ticket['ticket_code'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        _chip(
                          ticket['status'],
                          const Color(0xFFFFF3D6),
                          const Color(0xFFB45309),
                        ),
                        const SizedBox(width: 8),
                        _chip(
                          ticket['payment_status'],
                          const Color(0xFFFCE4E4),
                          const Color(0xFFB91C1C),
                        ),
                        const Spacer(),

                        if (ticket['status'] != 'completed')
                          ElevatedButton.icon(
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
                              backgroundColor: const Color(0xFF2E9D62),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),

                        const SizedBox(width: 12),

                        if (ticket['payment_status'] == 'unpaid')
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) =>
                                    PaymentModal(ticketId: ticket['ticket_code']),
                              );
                            },
                            icon: const Icon(Icons.credit_card),
                            label: const Text(
                              'Process Payment',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B6EF6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          'Submitted on ${ticket['created_at'].toString().substring(0, 16)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // 🔹 CONTENT ROW
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT CONTENT
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PRODUCT DETAILS',
                                style: TextStyle(
                                  letterSpacing: 1.2,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(
                                    child: _infoCard(
                                      'Product Type',
                                      ticket['product_type'],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _infoCard(
                                      'Brand & Model',
                                      ticket['product_brand_model'],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              const Text(
                                'ISSUE DESCRIPTION',
                                style: TextStyle(
                                  letterSpacing: 1.2,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  '"${ticket['problem_description']}"',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              const Text(
                                'ATTACHMENTS',
                                style: TextStyle(
                                  letterSpacing: 1.2,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              _attachmentBox(),
                            ],
                          ),
                        ),

                        const SizedBox(width: 28),

                        // RIGHT CUSTOMER CARD
                        SizedBox(
                          width: 340,
                          child: _customerCard(ticket),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentBox() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, color: Colors.grey),
          SizedBox(height: 6),
          Text(
            'No images uploaded',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _customerCard(Map<String, dynamic> ticket) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF020617)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.person_outline, color: Color(0xFF60A5FA)),
              SizedBox(width: 8),
              Text(
                'Customer Contact',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            ticket['customer_name'] ?? 'Unknown Customer',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            ticket['customer_phone'] ?? 'No phone provided',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),

          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFF3B6EF6),
                child: Text(
                  'FD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'SERVICE DESK',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1,
                      color: Colors.white54,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Front Desk A',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}