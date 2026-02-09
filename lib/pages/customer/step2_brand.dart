import 'package:flutter/material.dart';
import '../../models/ticket_form_model.dart';
import '../../core/ui_helpers.dart';
import 'step3_problem.dart';

class Step2Brand extends StatefulWidget {
  final TicketFormModel model;
  const Step2Brand({super.key, required this.model});

  @override
  State<Step2Brand> createState() => _Step2BrandState();
}

class _Step2BrandState extends State<Step2Brand> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validate);
  }

  void _validate() {
    setState(() {
      _isValid = _controller.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Center(
        child: FadeSlide(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  color: Colors.black.withOpacity(.08),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔹 Step Indicator
                const Text(
                  'STEP 2 OF 3',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 1.2,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                const Text(
                  'Tell us more',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                // 🔹 Brand & Model Input
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Brand & Model',
                    hintText: 'e.g. Dell XPS 15',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF3B6EF6),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // 🔹 Continue Button (NOW WORKS)
                ElevatedButton(
                  onPressed: _isValid
                      ? () {
                          widget.model.brandModel = _controller.text.trim();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  Step3Problem(model: widget.model),
                            ),
                          );
                        }
                      : null,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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