import 'package:flutter/material.dart';
import '../../models/ticket_form_model.dart';
import '../../core/ui_helpers.dart';
import 'step2_brand.dart';

class Step1Product extends StatefulWidget {
  const Step1Product({super.key});

  @override
  State<Step1Product> createState() => _Step1ProductState();
}

class _Step1ProductState extends State<Step1Product> {
  final TicketFormModel model = TicketFormModel();

  Widget card(String title, IconData icon) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        model.productType = title;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Step2Brand(model: model)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.06),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF3B6EF6)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: FadeSlide(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'STEP 1 OF 3',
              style: TextStyle(letterSpacing: 1.2, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              "What's the issue with?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    card('Laptop', Icons.laptop),
                    card('Printer', Icons.print),
                    card('Network', Icons.router),
                    card('Something Else', Icons.help_outline),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}