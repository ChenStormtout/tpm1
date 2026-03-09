import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';

class AritmatikaPage extends StatefulWidget {
  const AritmatikaPage({super.key});
  @override
  State<AritmatikaPage> createState() => _AritmatikaPageState();
}

class _AritmatikaPageState extends State<AritmatikaPage> {
  final _aCtrl = TextEditingController();
  final _bCtrl = TextEditingController();
  double? _hasil;
  bool? _isTambah;

  void _hitung(bool tambah) {
    final a = double.tryParse(_aCtrl.text);
    final b = double.tryParse(_bCtrl.text);
    if (a == null || b == null) return;
    setState(() {
      _isTambah = tambah;
      _hasil = tambah ? a + b : a - b;
    });
  }

  String _format(double v) =>
      v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Penjumlahan & Pengurangan')),
      body: Column(
        children: [
          buildPageHeader('Kalkulator Dasar', 'Masukkan dua angka'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                numField(_aCtrl, 'Angka Pertama (A)', hint: 'contoh: 10'),
                const SizedBox(height: 14),
                numField(_bCtrl, 'Angka Kedua (B)', hint: 'contoh: 5'),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _hitung(true),
                      icon: const Icon(Icons.add),
                      label: const Text('Jumlah'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: cPrimaryDark),
                      onPressed: () => _hitung(false),
                      icon: const Icon(Icons.remove),
                      label: const Text('Kurang'),
                    ),
                  ),
                ]),
                if (_hasil != null) ...[
                  const SizedBox(height: 20),
                  ResultCard(
                    label: _isTambah! ? 'A + B =' : 'A − B =',
                    value: _format(_hasil!),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
