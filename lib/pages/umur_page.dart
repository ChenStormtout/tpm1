import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/widgets.dart';

class UmurPage extends StatefulWidget {
  const UmurPage({super.key});
  @override
  State<UmurPage> createState() => _UmurPageState();
}

class _UmurPageState extends State<UmurPage> {
  DateTime? _birthDate;
  String _hasilUmur = '';

  Future<void> _pilihTanggalLahir() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 0, minute: 0),
      );

      if (pickedTime != null) {
        setState(() {
          _birthDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _hitungUmur();
        });
      }
    }
  }

  void _hitungUmur() {
    if (_birthDate == null) return;

    DateTime now = DateTime.now();
    int years = now.year - _birthDate!.year;
    int months = now.month - _birthDate!.month;
    int days = now.day - _birthDate!.day;
    int hours = now.hour - _birthDate!.hour;
    int minutes = now.minute - _birthDate!.minute;

    if (minutes < 0) {
      minutes += 60;
      hours--;
    }
    if (hours < 0) {
      hours += 24;
      days--;
    }
    if (days < 0) {
      months--;
      var prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      months += 12;
      years--;
    }

    _hasilUmur =
        '$years Tahun, $months Bulan,\n$days Hari, $hours Jam, $minutes Menit';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator Umur')),
      body: Column(
        children: [
          buildPageHeader(
            'Hitung Detail Umur',
            'Masukkan tanggal dan jam lahir Anda',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _pilihTanggalLahir,
                      icon: const Icon(Icons.cake),
                      label: const Text('Pilih Tanggal & Jam Lahir'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_birthDate != null) ...[
                    Text(
                      'Waktu Lahir: ${DateFormat('dd MMM yyyy, HH:mm').format(_birthDate!)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ResultCard(label: 'Umur Anda Saat Ini:', value: _hasilUmur),
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
