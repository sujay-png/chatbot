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
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        model.productType = title;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Step2Brand(model: model)),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.03)),
          boxShadow: [
            BoxShadow(
              blurRadius: 30,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(.04),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: const Color(0xFF3267F6)),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen width for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeSlide(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800), // Desktop friendly constraint
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Step Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3267F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'STEP 1 OF 3',
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3267F6),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "What's the issue with?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: GridView.count(
                    // Adjust columns based on screen width
                    crossAxisCount: isDesktop ? 4 : 2, 
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: isDesktop ? 1.1 : 0.9,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      card('Laptop', Icons.laptop_mac_rounded),
                      card('Printer', Icons.print_rounded),
                      card('Network', Icons.router_rounded),
                      card('Something Else', Icons.auto_awesome_motion_rounded),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}