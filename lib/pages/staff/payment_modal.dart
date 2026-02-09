import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentModal extends StatefulWidget {
  final String ticketId;
  const PaymentModal({super.key, required this.ticketId});

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  bool loading = false;

  Future<void> confirmPayment() async {
    setState(() => loading = true);

    await Supabase.instance.client
        .from('tickets')
        .update({'payment_status': 'paid'})
        .eq('ticket_code', widget.ticketId);

    setState(() => loading = false);

    Navigator.pop(context, true); // ✅ IMPORTANT
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F1F8),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code, size: 48, color: Color(0xFF3B6EF6)),
            const SizedBox(height: 16),

            const Text(
              'Scan to Pay',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),
            Text('Ticket ID: ${widget.ticketId}',
                style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 24),

            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('QR IMAGE HERE', style: TextStyle(color: Colors.grey)),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : confirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B6EF6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Confirm Payment Received',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}