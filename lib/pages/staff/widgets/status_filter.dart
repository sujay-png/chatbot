import 'package:flutter/material.dart';

class StatusFilter extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const StatusFilter({super.key, required this.selected, required this.onChanged});

  Widget chip(String label, String value) {
    final active = selected == value;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.white : const Color(0xFFF1F3F6),
          borderRadius: BorderRadius.circular(14),
          boxShadow: active
              ? const [BoxShadow(color: Color(0x11000000), blurRadius: 6)]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: active ? const Color(0xFF2563EB) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        chip('All', 'all'),
        const SizedBox(width: 12),
        chip('Open', 'open'),
        const SizedBox(width: 12),
        chip('Completed', 'completed'),
      ],
    );
  }
}