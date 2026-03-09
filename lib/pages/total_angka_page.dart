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
  double? _total;
  int _count = 0;

  void _hitung() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    final parts = text.split(RegExp(r'[,\s]+'));
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
      _total = sum;
      _count = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jumlah Total Angka')),
      body: Column(
        children: [
          buildPageHeader('Penjumlahan Banyak Angka',
              'Pisahkan angka dengan koma atau spasi'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                TextField(
                  controller: _ctrl,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Input Angka',
                    hintText: 'contoh: 10, 20, 30, 40',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 56),
                      child: Icon(Icons.list_alt),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _hitung,
                      child: const Text('Hitung Total')),
                ),
                if (_total != null) ...[
                  const SizedBox(height: 20),
                  ResultCard(
                    label: 'Jumlah dari $_count angka',
                    value: _total! % 1 == 0
                        ? _total!.toInt().toString()
                        : _total!.toStringAsFixed(4),
                  ),
                  const SizedBox(height: 12),
                  ResultCard(
                    label: 'Rata-rata',
                    value: _count > 0
                        ? (_total! / _count).toStringAsFixed(2)
                        : '0',
                    color: cAccent,
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
