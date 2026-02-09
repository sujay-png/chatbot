import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../ticket_detail_page.dart';

class TicketTable extends StatelessWidget {
  final String statusFilter;
  const TicketTable({super.key, required this.statusFilter});

  Future<List<dynamic>> fetchTickets() async {
    final supabase = Supabase.instance.client;
    var query = supabase.from('tickets').select();

    if (statusFilter != 'all') {
      query = query.eq('status', statusFilter);
    }

    return await query.order('created_at', ascending: false);
  }

  Color statusBg(String status) {
    switch (status) {
      case 'open':
        return Colors.orange.withOpacity(0.15);
      case 'in_progress':
        return Colors.blue.withOpacity(0.15);
      case 'completed':
        return Colors.green.withOpacity(0.15);
      default:
        return Colors.grey.withOpacity(0.15);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchTickets(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tickets = snapshot.data as List;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              _header(),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicketDetailPage(
                              ticketCode: ticket['ticket_code'],
                            ),
                          ),
                        );
                      },
                      child: _row(ticket),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: const [
          Expanded(child: Text('TICKET ID')),
          Expanded(flex: 2, child: Text('DEVICE / BRAND')),
          Expanded(child: Text('STATUS')),
          Expanded(child: Text('PAYMENT')),
          Expanded(child: Text('DATE')),
        ],
      ),
    );
  }

  Widget _row(dynamic ticket) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ticket['ticket_code'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ticket['product_brand_model']),
                Text(
                  ticket['product_type'],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: Chip(
              label: Text(ticket['status'].toUpperCase()),
              backgroundColor: statusBg(ticket['status']),
            ),
          ),
          Expanded(
            child: Chip(
              label: Text(ticket['payment_status'].toUpperCase()),
              backgroundColor: ticket['payment_status'] == 'paid'
                  ? Colors.green.withOpacity(0.15)
                  : Colors.red.withOpacity(0.15),
            ),
          ),
          Expanded(
            child: Text(
              ticket['created_at'].toString().substring(0, 10),
            ),
          ),
        ],
      ),
    );
  }
}