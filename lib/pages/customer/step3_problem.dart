import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/ticket_form_model.dart';
import 'success_screen.dart';

class Step3Problem extends StatefulWidget {
  final TicketFormModel model;
  const Step3Problem({super.key, required this.model});

  @override
  State<Step3Problem> createState() => _Step3ProblemState();
}

class _Step3ProblemState extends State<Step3Problem> {
  // Controllers
  final _problemController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  // Image handling
  final ImagePicker _picker = ImagePicker();
  XFile? _issueImage;
  XFile? _billImage;
  Uint8List? _issueBytes;
  Uint8List? _billBytes;

  bool _hasBill = false;
  bool _loading = false;

  // ---------------- IMAGE PICKERS ----------------

  Future<void> _pickIssueImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) _issueBytes = await picked.readAsBytes();
      setState(() => _issueImage = picked);
    }
  }

  Future<void> _pickBillImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) _billBytes = await picked.readAsBytes();
      setState(() => _billImage = picked);
    }
  }

  Widget _imagePreview(XFile file, Uint8List? bytes) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: kIsWeb
          ? Image.memory(bytes!, height: 120, fit: BoxFit.cover)
          : Image.file(File(file.path), height: 120, fit: BoxFit.cover),
    );
  }

  // ---------------- STORAGE UPLOAD ----------------

  Future<String> _uploadFile(String path, XFile file) async {
    final supabase = Supabase.instance.client;
    final bytes = await file.readAsBytes();

    await supabase.storage
        .from('ticket-images')
        .uploadBinary(path, bytes);

    return supabase.storage
        .from('ticket-images')
        .getPublicUrl(path);
  }

  // ---------------- SUBMIT ----------------

  Future<void> _submitTicket() async {
    if (_problemController.text.trim().isEmpty ||
        _nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _loading = true);
    final supabase = Supabase.instance.client;

    final ticketCode = await supabase.rpc('generate_ticket_code');

    String? issueImageUrl;
    String? billImageUrl;

    if (_issueImage != null) {
      issueImageUrl = await _uploadFile(
        'tickets/$ticketCode/issue.jpg',
        _issueImage!,
      );
    }

    if (_hasBill && _billImage != null) {
      billImageUrl = await _uploadFile(
        'tickets/$ticketCode/bill.jpg',
        _billImage!,
      );
    }

    await supabase.from('tickets').insert({
      'ticket_code': ticketCode,
      'product_type': widget.model.productType,
      'product_brand_model': widget.model.brandModel,
      'problem_description': _problemController.text.trim(),
      'image_url': issueImageUrl,
      'bill_url': billImageUrl,
      'customer_name': _nameController.text.trim(),
      'customer_phone': _phoneController.text.trim(),
    });

    setState(() => _loading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(ticketId: ticketCode),
      ),
    );
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  color: Colors.black.withOpacity(0.08),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // STEP INDICATOR
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Text(
                      'STEP 3 OF 3',
                      style: TextStyle(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),

                const SizedBox(height: 12),

                const Text(
                  'Describe the problem',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _problemController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        "The screen is flickering and won't turn on...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF3B6EF6),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                OutlinedButton.icon(
                  onPressed: _pickIssueImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text(
                    'Add Issue Photo',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),

                if (_issueImage != null) ...[
                  const SizedBox(height: 12),
                  _imagePreview(_issueImage!, _issueBytes),
                ],

                const SizedBox(height: 20),

                CheckboxListTile(
                  value: _hasBill,
                  onChanged: (v) {
                    setState(() {
                      _hasBill = v ?? false;
                      if (!_hasBill) _billImage = null;
                    });
                  },
                  title: const Text(
                    'I have a bill / invoice',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),

                if (_hasBill) ...[
                  OutlinedButton.icon(
                    onPressed: _pickBillImage,
                    icon: const Icon(Icons.receipt_long),
                    label: const Text(
                      'Upload Bill',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (_billImage != null) ...[
                    const SizedBox(height: 12),
                    _imagePreview(_billImage!, _billBytes),
                  ],
                ],

                const SizedBox(height: 24),

                const Text(
                  'Your contact details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _loading ? null : _submitTicket,
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit Ticket',
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