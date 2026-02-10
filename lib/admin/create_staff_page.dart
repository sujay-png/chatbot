import 'dart:convert';
import 'package:chatbot/core/supabase.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class CreateStaffPage extends StatefulWidget {
  const CreateStaffPage({super.key});

  @override
  State<CreateStaffPage> createState() => _CreateStaffPageState();
}

class _CreateStaffPageState extends State<CreateStaffPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  String center = 'udupi';
  bool loading = false;

  final supabase = Supabase.instance.client;




Future<void> createStaff() async {
  final session = Supabase.instance.client.auth.currentSession;
if (session == null) {
  _toast('You must be logged in as admin');
  return;
}
  setState(() => loading = true);

  try {
    final res = await Supabase.instance.client.functions.invoke(
      'create-staff',
      body: {
        'email': emailCtrl.text.trim(),
        'password': passwordCtrl.text.trim(),
        'service_center': center,
      },
    );

    if (res.data == null || res.data['success'] != true) {
      throw res.data?['error'] ?? 'Failed to create staff';
    }

    emailCtrl.clear();
    passwordCtrl.clear();
    _toast('Staff created successfully ✅');

  } catch (e) {
    _toast(e.toString());
  } finally {
    setState(() => loading = false);
  }
}

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Create Staff'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _input('Email', emailCtrl),
              const SizedBox(height: 16),
              _input('Password', passwordCtrl, obscure: true),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: center,
                decoration: _decoration('Service Center'),
                items: const [
                  DropdownMenuItem(value: 'bengaluru', child: Text('Bengaluru')),
                  DropdownMenuItem(value: 'mangaluru', child: Text('Mangaluru')),
                  DropdownMenuItem(value: 'udupi', child: Text('Udupi')),
                ],
                onChanged: (v) => setState(() => center = v!),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : createStaff,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B2FFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Create Staff',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController c,
      {bool obscure = false}) {
    return TextField(
      controller: c,
      obscureText: obscure,
      decoration: _decoration(label),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      );
}