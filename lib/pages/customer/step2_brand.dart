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
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView( // Prevents overflow when keyboard appears
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FadeSlide(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🔹 Step Indicator (Consistent Badge Style)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3267F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        'STEP 2 OF 3',
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF3267F6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Tell us more',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Which device are you having trouble with?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 🔹 Brand & Model Input (Refined Look)
                  TextField(
                    controller: _controller,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      labelText: 'Brand & Model',
                      hintText: 'e.g. Dell XPS 15',
                      prefixIcon: const Icon(Icons.devices_other_rounded, color: Color(0xFF3267F6)),
                      labelStyle: const TextStyle(color: Color(0xFF64748B)),
                      floatingLabelStyle: const TextStyle(color: Color(0xFF3267F6), fontWeight: FontWeight.bold),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FB),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF3267F6),
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // 🔹 Continue Button (Consistent Full-Width Style)
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isValid
                          ? () {
                              widget.model.brandModel = _controller.text.trim();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Step3Problem(model: widget.model),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3267F6),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade200,
                        disabledForegroundColor: Colors.grey.shade500,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}