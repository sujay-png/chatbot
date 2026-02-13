import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssignTechnicianModal extends StatefulWidget {
  final String ticketCode;
  final String serviceCenter;

  const AssignTechnicianModal({
    super.key,
    required this.ticketCode,
    required this.serviceCenter,
  });

  @override
  State<AssignTechnicianModal> createState() =>
      _AssignTechnicianModalState();
}

class _AssignTechnicianModalState
    extends State<AssignTechnicianModal> {
  final supabase = Supabase.instance.client;

  List technicians = [];
  String? selectedId;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchTechnicians();
  }

  Future<void> fetchTechnicians() async {
    final data = await supabase
        .from('technicians')
        .select()
        .eq('service_center', widget.serviceCenter);

    setState(() {
      technicians = data;
      loading = false;
    });
  }

  Future<void> assign() async {
    if (selectedId == null) return;

    await supabase
        .from('tickets')
        .update({'technician_id': selectedId})
        .eq('ticket_code', widget.ticketCode);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(28),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Assign Technician",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  DropdownButtonFormField<String>(
                    initialValue: selectedId,
                    decoration: const InputDecoration(
                      labelText: "Select Technician",
                    ),
                    items: technicians.map<DropdownMenuItem<String>>((tech) {
                      return DropdownMenuItem<String>(
                        value: tech['id'],
                        child: Text(tech['name']),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => selectedId = val),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: assign,
                      child: const Text("Assign"),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}