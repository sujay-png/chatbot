import 'package:flutter/material.dart';
import '../../core/ui_helpers.dart'; // Assuming this contains FadeSlide
import 'step1_product.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Matches the light grey background
      body: Center(
        child: FadeSlide(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40), // Softer, larger radius
              boxShadow: [
                BoxShadow(
                  blurRadius: 40,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(.05),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Container
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined, // Closer to the outlined shield look
                    size: 36,
                    color: Color(0xFF3267F6),
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                const Text(
                  'Report a Problem',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800, // Extra bold
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                // Description
                const Text(
                  "Tell us the issue you're facing and we'll help you get it resolved quickly.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                    height: 1.5, // Better line height for readability
                  ),
                ),
                const SizedBox(height: 48),
                // Action Button
                SizedBox(
                  width: double.infinity, // Makes it full width like the screenshot
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Step1Product()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3267F6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Start',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
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