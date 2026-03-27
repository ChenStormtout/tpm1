import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Penting untuk FilteringTextInputFormatter
import '../utils/constants.dart';
import '../widgets/widgets.dart';

class PiramidPage extends StatefulWidget {
  const PiramidPage({super.key});

  @override
  State<PiramidPage> createState() => _PiramidPageState();
}

class _PiramidPageState extends State<PiramidPage> {
  final _aCtrl = TextEditingController();
  final _tCtrl = TextEditingController();
  
  // State untuk hasil
  double? _luasAlas, _luasPermukaan, _volume;

  // Helper untuk SnackBar agar tidak duplikat kode
  void _notify(String message, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _hitung() {
    // 1. Ambil dan bersihkan input
    final String aInput = _aCtrl.text.trim().replaceAll(',', '.');
    final String tInput = _tCtrl.text.trim().replaceAll(',', '.');

    // 2. Validasi: Kosong
    if (aInput.isEmpty || tInput.isEmpty) {
      _notify("Ups! Sisi alas dan tinggi tidak boleh kosong.", cError);
      return;
    }

    // 3. Validasi: Format Angka (RegExp yang benar)
    final RegExp numericRegex = RegExp(r'^\d*\.?\d+$');
    if (!numericRegex.hasMatch(aInput) || !numericRegex.hasMatch(tInput)) {
      _notify("Gunakan format angka yang benar (contoh: 10.5)", cError);
      return;
    }

    final double? a = double.tryParse(aInput);
    final double? t = double.tryParse(tInput);

    // 4. Validasi: Parsing gagal atau Angka Nol/Negatif
    if (a == null || t == null) {
      _notify("Gagal memproses angka. Periksa kembali input Anda.", cError);
      return;
    }

    if (a <= 0 || t <= 0) {
      _notify("Nilai harus lebih besar dari 0!", Colors.orange);
      return;
    }

    // 5. Validasi: Keamanan Kalkulasi (Mencegah angka terlalu besar)
    if (a > 1000000 || t > 1000000) {
      _notify("Angka terlalu besar! Aplikasi membatasi hingga 1.000.000", Colors.purple);
      return;
    }

    // --- LOGIKA PERHITUNGAN ---
    // Rumus Tinggi Sisi Tegak (Phytagoras): s = sqrt((a/2)^2 + t^2)
    final double tinggiSisiTegak = sqrt(pow(a / 2, 2) + pow(t, 2));

    setState(() {
      _luasAlas = a * a;
      _luasPermukaan = (a * a) + (4 * (0.5 * a * tinggiSisiTegak));
      _volume = (1 / 3) * (a * a) * t;
    });

    _notify("Perhitungan selesai!", cAccent);
    FocusScope.of(context).unfocus(); // Menutup keyboard otomatis
  }

  void _reset() {
    setState(() {
      _aCtrl.clear();
      _tCtrl.clear();
      _luasAlas = null;
      _luasPermukaan = null;
      _volume = null;
    });
    _notify("Data telah direset", Colors.grey);
  }

  @override
  void dispose() {
    _aCtrl.dispose();
    _tCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Piramid'),
        actions: [
          IconButton(onPressed: _reset, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: Column(
        children: [
          buildPageHeader(
            'Limas Segi Empat', 
            'Hitung Luas Alas, Permukaan, dan Volume secara akurat.'
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Visualisasi Piramid
                  Container(
                    height: 140,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cPrimary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomPaint(
                      size: const Size(120, 100),
                      painter: _PyramidPainter(),
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Input Fields
                  _buildInputCard(),
                  
                  const SizedBox(height: 20),
                  
                  // Tombol Hitung
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _hitung,
                      icon: const Icon(Icons.calculate_outlined, color: Colors.white),
                      label: const Text('HITUNG SEKARANG', 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                      ),
                    ),
                  ),

                  // Hasil Perhitungan
                  if (_volume != null) ...[
                    const SizedBox(height: 30),
                    _buildResultSection(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 0,
      color: cSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            numField(
              _aCtrl, 
              'Sisi Alas (a)', 
              hint: 'Contoh: 12',
            ),
            const SizedBox(height: 15),
            numField(
              _tCtrl, 
              'Tinggi Limas (t)', 
              hint: 'Contoh: 8',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    // Kamu bisa mengganti 'cm' dengan unit apapun atau dikosongkan
    const String unitL = "cm²"; 
    const String unitV = "cm³";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Hasil Perhitungan:", 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cText)),
        const SizedBox(height: 15),
        ResultCard(
          label: 'Luas Alas', 
          value: '${_luasAlas!.toStringAsFixed(2)} $unitL',
        ),
        const SizedBox(height: 10),
        ResultCard(
          label: 'Luas Permukaan', 
          value: '${_luasPermukaan!.toStringAsFixed(2)} $unitL',
          color: cAccent,
        ),
        const SizedBox(height: 10),
        ResultCard(
          label: 'Volume Piramid', 
          value: '${_volume!.toStringAsFixed(2)} $unitV',
          color: cPrimaryDark,
        ),
      ],
    );
  }
}

// Painter diperbaiki agar lebih stabil
class _PyramidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = cPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final fill = Paint()
      ..color = cPrimary.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final double w = size.width;
    final double h = size.height;

    final apex = Offset(w / 2, 0);
    final bl = Offset(w * 0.1, h * 0.9);
    final br = Offset(w * 0.7, h * 0.9);
    final bm = Offset(w * 0.9, h * 0.6);
    final blm = Offset(w * 0.3, h * 0.6);

    // Gambar Sisi Belakang (Putus-putus manual)
    canvas.drawLine(bl, blm, stroke..color = cPrimary.withOpacity(0.3));
    canvas.drawLine(blm, bm, stroke);
    canvas.drawLine(blm, apex, stroke);

    // Gambar Sisi Depan
    final pathFront = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(bl.dx, bl.dy)
      ..lineTo(br.dx, br.dy)
      ..close();
    
    canvas.drawPath(pathFront, fill);
    canvas.drawPath(pathFront, stroke..color = cPrimary);
    canvas.drawLine(apex, br, stroke);
    canvas.drawLine(br, bm, stroke);
    canvas.drawLine(apex, bm, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}