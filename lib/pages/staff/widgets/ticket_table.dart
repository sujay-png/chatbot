import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../ticket_detail_page.dart';

class TicketTable extends StatefulWidget {
  final String filter;
  final String search;
  final bool isAdmin;
  final String? serviceCenter;

  const TicketTable({
    super.key,
    required this.filter,
    required this.search,
    required this.isAdmin,
    this.serviceCenter,
  });

  @override
  State<TicketTable> createState() => _TicketTableState();
}

class _TicketTableState extends State<TicketTable> {
  final supabase = Supabase.instance.client;

Future<List<dynamic>> fetchTickets() async {
  print('🧪 isAdmin: ${widget.isAdmin}');
  print('🧪 serviceCenter: ${widget.serviceCenter}');
  print('🧪 filter: ${widget.filter}');
  print('🧪 search: ${widget.search}');

  var query = supabase.from('tickets').select();

  if (!widget.isAdmin && widget.serviceCenter != null) {
    query = query.eq('service_center', widget.serviceCenter!);
  }

  if (widget.filter != 'all') {
    query = query.eq('status', widget.filter);
  }

  if (widget.search.isNotEmpty) {
    query = query.ilike('ticket_code', '%${widget.search}%');
  }

  final result = await query.order('created_at', ascending: false);

  print('🧪 tickets fetched: ${result.length}');
  return result;
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchTickets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No tickets found',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final tickets = snapshot.data!;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE6EBF2)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _header(),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: tickets.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Color(0xFFF1F3F6)),
                  itemBuilder: (context, index) {
                    final t = tickets[index];
                    return _row(context, t);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- UI ----------------

  Widget _header() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Row(
        children: [
          Expanded(child: _HeaderText('TICKET ID')),
          Expanded(flex: 2, child: _HeaderText('DEVICE / BRAND')),
          Expanded(child: _HeaderText('STATUS')),
          Expanded(child: _HeaderText('PAYMENT')),
          Expanded(child: _HeaderText('DATE')),
          SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, dynamic t) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TicketDetailPage(ticketCode: t['ticket_code']),
          ),
        );

        // 🔄 Refresh after returning
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                t['ticket_code'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t['product_brand_model'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t['product_type'],
                    style: const TextStyle(color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _statusChip(t['status']),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _paymentChip(t['payment_status']),
              ),
            ),

            Expanded(
              child: Text(
                t['created_at'].toString().substring(0, 10),
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
            ),

            const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String s) {
    if (s == 'completed') {
      return _chip('COMPLETED', Colors.green.shade100, Colors.green.shade700);
    }
    return _chip('OPEN', const Color(0xFFFFF3D6), const Color(0xFFB45309));
  }

  Widget _paymentChip(String p) {
    if (p == 'paid') {
      return _chip('PAID', const Color(0xFFD1FAE5), const Color(0xFF065F46));
    }
    return _chip('UNPAID', const Color(0xFFFDE2E2), const Color(0xFFB91C1C));
  }

  Widget _chip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: fg,
        ),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        letterSpacing: 1,
        fontWeight: FontWeight.w600,
        color: Color(0xFF8A94A6),
      ),
    );
  }
}
