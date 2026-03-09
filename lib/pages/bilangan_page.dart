import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';

class BilanganPage extends StatefulWidget {
  const BilanganPage({super.key});
  @override
  State<BilanganPage> createState() => _BilanganPageState();
}

class _BilanganPageState extends State<BilanganPage> {
  final _ctrl = TextEditingController();
  int? _n;

  bool _isPrima(int n) {
    if (n < 2) return false;
    for (int i = 2; i <= sqrt(n); i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  void _cek() {
    final n = int.tryParse(_ctrl.text);
    if (n == null) return;
    setState(() => _n = n);
  }

  @override
  Widget build(BuildContext context) {
    final isGanjil = _n != null ? _n! % 2 != 0 : null;
    final isPrima = _n != null ? _isPrima(_n!) : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Ganjil/Genap & Prima')),
      body: Column(
        children: [
          buildPageHeader('Cek Bilangan', 'Masukkan bilangan bulat'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                TextField(
                  controller: _ctrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Bilangan',
                    prefixIcon: Icon(Icons.numbers),
                    hintText: 'contoh: 17',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _cek,
                      child: const Text('Cek Sekarang')),
                ),
                if (_n != null) ...[
                  const SizedBox(height: 20),
                  ResultCard(
                    label: 'Ganjil / Genap',
                    value: isGanjil!
                        ? '$_n → Ganjil (Odd)'
                        : '$_n → Genap (Even)',
                    color: isGanjil ? cPrimary : cAccent,
                  ),
                  const SizedBox(height: 12),
                  ResultCard(
                    label: 'Bilangan Prima',
                    value: isPrima!
                        ? '$_n → Prima ✓'
                        : '$_n → Bukan Prima ✗',
                    color: isPrima ? cPrimary : cError,
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
