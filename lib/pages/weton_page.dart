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
  String _hasilPasaran = '';
  int _neptuHari = 0;
  int _neptuPasaran = 0;
  int _totalNeptu = 0;

  final List<String> _namaHari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  final List<String> _namaPasaran = [
    'Legi',
    'Pahing',
    'Pon',
    'Wage',
    'Kliwon',
  ];

  final Map<String, int> _neptuHariMap = {
    'Senin': 4,
    'Selasa': 3,
    'Rabu': 7,
    'Kamis': 8,
    'Jumat': 6,
    'Sabtu': 9,
    'Minggu': 5,
  };

  final Map<String, int> _neptuPasaranMap = {
    'Legi': 5,
    'Pahing': 9,
    'Pon': 7,
    'Wage': 4,
    'Kliwon': 8,
  };

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    final hari = _namaHari[picked.weekday - 1];

    // Referensi: 1 Januari 1970 = Kamis Wage
    // Index Wage pada list _namaPasaran adalah 3
    int selisihHari = picked.difference(DateTime(1970, 1, 1)).inDays;
    int indexPasaran = (selisihHari + 3) % 5;

    if (indexPasaran < 0) {
      indexPasaran += 5;
    }

    final pasaran = _namaPasaran[indexPasaran];
    final neptuHari = _neptuHariMap[hari] ?? 0;
    final neptuPasaran = _neptuPasaranMap[pasaran] ?? 0;

    setState(() {
      _selectedDate = picked;
      _hasilHari = hari;
      _hasilPasaran = pasaran;
      _neptuHari = neptuHari;
      _neptuPasaran = neptuPasaran;
      _totalNeptu = neptuHari + neptuPasaran;
    });
  }

  void _reset() {
    setState(() {
      _selectedDate = null;
      _hasilHari = '';
      _hasilPasaran = '';
      _neptuHari = 0;
      _neptuPasaran = 0;
      _totalNeptu = 0;
    });
  }

  Widget _infoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.withOpacity(0.4)),
      ),
      child: const Text(
        'Catatan: Perhitungan ini menampilkan hari, pasaran, dan neptu berdasarkan tradisi kalender Jawa. '
        'Hasil ini bukan penentu sifat, nasib, atau kualitas seseorang.',
        style: TextStyle(fontSize: 14, height: 1.4),
      ),
    );
  }

  Widget _neptuDetailCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Neptu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _rowInfo('Hari', '$_hasilHari = $_neptuHari'),
          _rowInfo('Pasaran', '$_hasilPasaran = $_neptuPasaran'),
          const Divider(height: 24),
          _rowInfo(
            'Total Neptu',
            '$_neptuHari + $_neptuPasaran = $_totalNeptu',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _rowInfo(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _explanationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.25)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apa itu Weton?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Weton adalah gabungan antara hari biasa dan pasaran Jawa. '
            'Contohnya Senin Legi, Rabu Pon, atau Jumat Kliwon.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          SizedBox(height: 12),
          Text(
            'Apa itu Neptu?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Neptu adalah nilai angka yang diberikan pada hari dan pasaran dalam tradisi Jawa. '
            'Nilai ini biasanya digunakan untuk perhitungan adat atau referensi budaya.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _selectedDate == null
        ? ''
        : DateFormat('dd MMMM yyyy').format(_selectedDate!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hari & Weton'),
        actions: [
          if (_selectedDate != null)
            IconButton(
              onPressed: _reset,
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset',
            ),
        ],
      ),
      body: Column(
        children: [
          buildPageHeader(
            'Cek Hari dan Weton',
            'Masukkan tanggal untuk mengetahui hari, pasaran, dan neptu Jawa',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _pilihTanggal,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _selectedDate == null
                            ? 'Pilih Tanggal'
                            : 'Ganti Tanggal',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  _infoCard(),

                  if (_selectedDate != null) ...[
                    const SizedBox(height: 24),

                    ResultCard(
                      label: 'Tanggal Dipilih',
                      value: formattedDate,
                    ),

                    const SizedBox(height: 12),

                    ResultCard(
                      label: 'Hari',
                      value: _hasilHari,
                    ),

                    const SizedBox(height: 12),

                    ResultCard(
                      label: 'Pasaran',
                      value: _hasilPasaran,
                      color: cAccent,
                    ),

                    const SizedBox(height: 12),

                    ResultCard(
                      label: 'Weton',
                      value: '$_hasilHari $_hasilPasaran',
                      color: Colors.green,
                    ),

                    const SizedBox(height: 12),

                    ResultCard(
                      label: 'Total Neptu',
                      value: _totalNeptu.toString(),
                      color: Colors.deepPurple,
                    ),

                    const SizedBox(height: 20),

                    _neptuDetailCard(),
                  ],

                  const SizedBox(height: 20),
                  _explanationCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}