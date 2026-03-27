import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';

class WetonPage extends StatefulWidget {
  const WetonPage({super.key});
  @override
  State<WetonPage> createState() => _WetonPageState();
}

class _WetonPageState extends State<WetonPage> {
  DateTime? _selectedDate;
  String _hasilHari = '';
  String _hasilWeton = '';

  final List<String> _namaHari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  final List<String> _namaPasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // Perhitungan Pasaran Jawa (Weton)
      // 1 Januari 1970 adalah hari Kamis Wage (Index pasaran Wage adalah 3)
      int selisihHari = picked.difference(DateTime(1970, 1, 1)).inDays;
      int indexPasaran = (selisihHari + 3) % 5;
      if (indexPasaran < 0) indexPasaran += 5;

      setState(() {
        _selectedDate = picked;
        _hasilHari = _namaHari[picked.weekday - 1];
        _hasilWeton = _namaPasaran[indexPasaran];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hari & Weton')),
      body: Column(
        children: [
          buildPageHeader('Cek Hari dan Weton', 'Masukkan tanggal untuk mengetahui pasaran Jawa'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _pilihTanggal,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Pilih Tanggal'),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_selectedDate != null) ...[
                    Text(
                      'Tanggal Dipilih: ${DateFormat('dd MMMM yyyy').format(_selectedDate!)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),
                    ResultCard(label: 'Hari Biasa', value: _hasilHari),
                    const SizedBox(height: 12),
                    ResultCard(label: 'Pasaran (Weton)', value: _hasilWeton, color: cAccent),
                    const SizedBox(height: 12),
                    ResultCard(label: 'Kombinasi', value: '$_hasilHari $_hasilWeton', color: Colors.green),
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