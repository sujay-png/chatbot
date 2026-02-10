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
  String selectedCenter = '';
  final _problemController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

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

  // Refined Image Preview Widget
  Widget _imagePreview(XFile file, Uint8List? bytes) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFF3FF), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: kIsWeb
            ? Image.memory(bytes!, height: 160, width: double.infinity, fit: BoxFit.cover)
            : Image.file(File(file.path), height: 160, width: double.infinity, fit: BoxFit.cover),
      ),
    );
  }

  // ---------------- STORAGE UPLOAD ----------------
  Future<String> _uploadFile(String path, XFile file) async {
    final supabase = Supabase.instance.client;
    final bytes = await file.readAsBytes();
    await supabase.storage.from('ticket-images').uploadBinary(path, bytes);
    return supabase.storage.from('ticket-images').getPublicUrl(path);
  }

  // ---------------- SUBMIT ----------------
  Future<void> _submitTicket() async {
    if (selectedCenter.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a service center')));
      return;
    }
    if (_problemController.text.trim().isEmpty || _nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields')));
      return;
    }

    setState(() => _loading = true);
    final supabase = Supabase.instance.client;
    final ticketCode = await supabase.rpc('generate_ticket_code');

    String? issueImageUrl;
    String? billImageUrl;

    if (_issueImage != null) {
      issueImageUrl = await _uploadFile('tickets/$ticketCode/issue.jpg', _issueImage!);
    }

    if (_hasBill && _billImage != null) {
      billImageUrl = await _uploadFile('tickets/$ticketCode/bill.jpg', _billImage!);
    }

    await supabase.from('tickets').insert({
      'ticket_code': ticketCode,
      'product_type': widget.model.productType,
      'product_brand_model': widget.model.brandModel,
      'problem_description': _problemController.text.trim(),
      'image_url': issueImageUrl,
      'bill_url': billImageUrl,
      'service_center': selectedCenter,
      'customer_name': _nameController.text.trim(),
      'customer_phone': _phoneController.text.trim(),
    });

    setState(() => _loading = false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SuccessScreen(ticketId: ticketCode)));
  }

  // Utility method for Section Headers
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
      ),
    );
  }

  // Utility for Input Decoration
  InputDecoration _inputStyle(String label, {IconData? icon, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF3267F6), size: 20) : null,
      filled: true,
      fillColor: const Color(0xFFF8F9FB),
      floatingLabelStyle: const TextStyle(color: Color(0xFF3267F6), fontWeight: FontWeight.bold),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF3267F6), width: 2),
      ),
    );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(blurRadius: 40, offset: const Offset(0, 10), color: Colors.black.withOpacity(.05)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // STEP BADGE
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3267F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      'STEP 3 OF 3',
                      style: TextStyle(letterSpacing: 1.5, fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF3267F6)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Final Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1E293B), letterSpacing: -0.5),
                ),
                const SizedBox(height: 32),

                // PROBLEM DESCRIPTION
                _sectionTitle('Problem Description'),
                TextField(
                  controller: _problemController,
                  maxLines: 4,
                  decoration: _inputStyle('Describe the issue', hint: "e.g. The screen is flickering..."),
                ),
                const SizedBox(height: 16),
                
                // ISSUE PHOTO BUTTON
                OutlinedButton.icon(
                  onPressed: _pickIssueImage,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    side: const BorderSide(color: Color(0xFF3267F6)),
                  ),
                  icon: const Icon(Icons.add_a_photo_rounded, size: 20),
                  label: const Text('Add Issue Photo', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                if (_issueImage != null) _imagePreview(_issueImage!, _issueBytes),

                const SizedBox(height: 24),
                const Divider(height: 32),

                // BILL UPLOAD
                CheckboxListTile(
                  value: _hasBill,
                  onChanged: (v) {
                    setState(() {
                      _hasBill = v ?? false;
                      if (!_hasBill) _billImage = null;
                    });
                  },
                  title: const Text('I have a bill / invoice', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFF3267F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                if (_hasBill) ...[
                  OutlinedButton.icon(
                    onPressed: _pickBillImage,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.receipt_long_rounded, size: 20),
                    label: const Text('Upload Bill', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  if (_billImage != null) _imagePreview(_billImage!, _billBytes),
                ],

                const SizedBox(height: 24),
                const Divider(height: 32),

                // CONTACT DETAILS
                _sectionTitle('Contact Information'),
                TextField(
                  controller: _nameController,
                  decoration: _inputStyle('Full Name', icon: Icons.person_outline_rounded),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputStyle('Phone Number', icon: Icons.phone_android_rounded),
                ),

                const SizedBox(height: 24),
                _sectionTitle('Service Center'),
                DropdownButtonFormField<String>(
                  initialValue: selectedCenter.isEmpty ? null : selectedCenter,
                  hint: const Text('Select nearest center'),
                  items: const [
                    DropdownMenuItem(value: 'bengaluru', child: Text('Bengaluru')),
                    DropdownMenuItem(value: 'mangaluru', child: Text('Mangaluru')),
                    DropdownMenuItem(value: 'udupi', child: Text('Udupi')),
                  ],
                  onChanged: (value) => setState(() => selectedCenter = value!),
                  decoration: _inputStyle('', icon: Icons.location_on_outlined),
                ),

                const SizedBox(height: 48),

                // SUBMIT BUTTON
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submitTicket,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3267F6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                        : const Text('Submit Ticket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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