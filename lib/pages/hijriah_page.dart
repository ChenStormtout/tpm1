import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';

class HijriahPage extends StatefulWidget {
  const HijriahPage({super.key});
  @override
  State<HijriahPage> createState() => _HijriahPageState();
}

class _HijriahPageState extends State<HijriahPage> {
  DateTime? _selectedDate;
  String _hasilHijriah = '';

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // Inisialisasi bahasa ke lokal (opsional, defaultnya bahasa Inggris/Arab)
      HijriCalendar.setLocal('en');

      final hijriDate = HijriCalendar.fromDate(picked);

      setState(() {
        _selectedDate = picked;
        _hasilHijriah = hijriDate.toFormat("dd MMMM yyyy") + " H";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konversi Hijriah')),
      body: Column(
        children: [
          buildPageHeader(
            'Masehi ke Hijriah',
            'Konversi penanggalan internasional ke kalender Islam',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _pilihTanggal,
                      icon: const Icon(Icons.mosque),
                      label: const Text('Pilih Tanggal Masehi'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_selectedDate != null) ...[
                    Text(
                      'Masehi: ${DateFormat('dd MMMM yyyy').format(_selectedDate!)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ResultCard(
                      label: 'Kalender Hijriah:',
                      value: _hasilHijriah,
                      color: cAccent,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
