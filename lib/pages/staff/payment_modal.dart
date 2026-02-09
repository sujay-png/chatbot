import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentModal extends StatelessWidget {
  final String ticketId;
  const PaymentModal({super.key, required this.ticketId});

  Future<void> markPaid(BuildContext context) async {
    final supabase = Supabase.instance.client;

    await supabase
        .from('tickets')
        .update({'payment_status': 'paid'})
        .eq('ticket_code', ticketId);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          width: 420, // ✅ FIXED WIDTH (no full screen)
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF020617)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 QR ICON (no asset dependency)
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.qr_code_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Scan to Pay',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Ticket ID: $ticketId',
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 QR PLACEHOLDER
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Icon(
                    Icons.qr_code,
                    size: 120,
                    color: Colors.white24,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 CONFIRM BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => markPaid(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B6EF6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Confirm Payment Received',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}