import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

/// Header gradient di bagian atas setiap halaman
Widget buildPageHeader(String title, String subtitle) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [cPrimary, cPrimaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 4),
        Text(subtitle,
            style:
                TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.75))),
      ],
    ),
  );
}

/// Card hasil perhitungan
class ResultCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const ResultCard(
      {super.key, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? cPrimary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: c)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: c)),
        ],
      ),
    );
  }
}

/// TextField khusus angka
Widget numField(TextEditingController c, String label, {String? hint}) =>
    TextField(
      controller: c,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[-0-9.]'))
      ],
      decoration: InputDecoration(labelText: label, hintText: hint),
    );