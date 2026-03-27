import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';

class TotalAngkaPage extends StatefulWidget {
  const TotalAngkaPage({super.key});
  @override
  State<TotalAngkaPage> createState() => _TotalAngkaPageState();
}

class _TotalAngkaPageState extends State<TotalAngkaPage> {
  final _ctrl = TextEditingController();
  
  // --- State Fitur Sebelumnya (Angka) ---
  double? _total;
  int _numCount = 0;

  // --- State Fitur Baru (Karakter/Huruf) ---
  int _charCount = 0;
  int _wordCount = 0;

  void _hitung() {
    final rawText = _ctrl.text;
    final trimmedText = rawText.trim();

    if (rawText.isEmpty) {
      setState(() {
        _total = null;
        _numCount = 0;
        _charCount = 0;
        _wordCount = 0;
      });
      return;
    }

    // 1. LOGIKA FITUR BARU (Hitung Huruf/Karakter)
    // "anjing" -> 6 karakter
    int charCount = rawText.length; 
    
    // Hitung kata (pisahkan berdasarkan spasi)
    int wordCount = trimmedText.isEmpty ? 0 : trimmedText.split(RegExp(r'\s+')).length;

    // 2. LOGIKA FITUR SEBELUMNYA (Penjumlahan Angka)
    final parts = trimmedText.split(RegExp(r'[,\s\n]+'));
    double sum = 0;
    int count = 0;
    
    for (final p in parts) {
      final n = double.tryParse(p);
      if (n != null) {
        sum += n;
        count++;
      }
    }

    setState(() {
      _charCount = charCount;
      _wordCount = wordCount;
      _total = sum;
      _numCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Total Angka & Karakter')),
      body: Column(
        children: [
          buildPageHeader(
            'Penghitung Serbaguna',
            'Input teks untuk hitung huruf, input angka untuk dijumlahkan',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _ctrl,
                    maxLines: 5,
                    onChanged: (val) => _hitung(), // Hitung otomatis saat mengetik
                    decoration: const InputDecoration(
                      labelText: 'Kotak Input',
                      hintText: '',
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 80),
                        child: Icon(Icons.text_fields),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // --- Tampilan Hasil Fitur Baru (Karakter) ---
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("📝 Analisis Teks", 
                      style: TextStyle(fontWeight: FontWeight.bold, color: cPrimary)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ResultCard(
                          label: 'Total Karakter', 
                          value: '$_charCount',
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ResultCard(
                          label: 'Total Kata', 
                          value: '$_wordCount',
                          color: cAccent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // --- Tampilan Hasil Fitur Sebelumnya (Angka) ---
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("🔢 Penjumlahan Angka", 
                      style: TextStyle(fontWeight: FontWeight.bold, color: cPrimaryDark)),
                  ),
                  const SizedBox(height: 10),
                  ResultCard(
                    label: 'Jumlah dari $_numCount angka',
                    value: _total == null ? '0' : (_total! % 1 == 0 
                        ? _total!.toInt().toString() 
                        : _total!.toStringAsFixed(2)),
                  ),
                  if (_numCount > 0) ...[
                    const SizedBox(height: 10),
                    ResultCard(
                      label: 'Rata-rata Angka',
                      value: (_total! / _numCount).toStringAsFixed(2),
                      color: cPrimaryDark,
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