import 'dart:math';
import 'package:flutter/material.dart';
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
  double? _luasAlas, _luasPermukaan, _volume;

  void _hitung() {
    final a = double.tryParse(_aCtrl.text);
    final t = double.tryParse(_tCtrl.text);
    if (a == null || t == null || a <= 0 || t <= 0) return;

    final tinggiSisi = sqrt((a / 2) * (a / 2) + t * t);
    setState(() {
      _luasAlas = a * a;
      _luasPermukaan = (a * a) + 4 * (0.5 * a * tinggiSisi);
      _volume = (1 / 3) * (a * a) * t;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Luas & Volume Piramid')),
      body: Column(
        children: [
          buildPageHeader(
              'Piramid Alas Persegi', 'Masukkan panjang alas dan tinggi'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                SizedBox(
                  height: 120,
                  child: CustomPaint(
                      size: const Size(120, 100),
                      painter: _PyramidPainter()),
                ),
                const SizedBox(height: 16),
                numField(_aCtrl, 'Panjang Sisi Alas (a)',
                    hint: 'contoh: 6'),
                const SizedBox(height: 14),
                numField(_tCtrl, 'Tinggi Piramid (t)', hint: 'contoh: 4'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _hitung, child: const Text('Hitung')),
                ),
                if (_volume != null) ...[
                  const SizedBox(height: 20),
                  ResultCard(
                    label: 'Luas Alas  (a²)',
                    value:
                        '${_luasAlas!.toStringAsFixed(2)} satuan²',
                  ),
                  const SizedBox(height: 12),
                  ResultCard(
                    label: 'Luas Permukaan  (alas + 4 sisi)',
                    value:
                        '${_luasPermukaan!.toStringAsFixed(2)} satuan²',
                    color: cAccent,
                  ),
                  const SizedBox(height: 12),
                  ResultCard(
                    label: 'Volume  (⅓ × a² × t)',
                    value: '${_volume!.toStringAsFixed(2)} satuan³',
                    color: cPrimaryDark,
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

class _PyramidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = cPrimary.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final fill = Paint()
      ..color = cPrimary.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final dashed = Paint()
      ..color = cPrimary.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final apex = Offset(size.width / 2, 0);
    final bl = Offset(10, size.height);
    final br = Offset(size.width - 10, size.height);
    final bm = Offset(size.width * 0.75, size.height * 0.7);
    final blm = Offset(size.width * 0.25, size.height * 0.7);

    final front = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(bl.dx, bl.dy)
      ..lineTo(br.dx, br.dy)
      ..close();
    canvas.drawPath(front, fill);
    canvas.drawPath(front, stroke);
    canvas.drawLine(apex, bm, stroke);
    canvas.drawLine(bl, blm, dashed);
    canvas.drawLine(blm, bm, dashed);
    canvas.drawLine(bm, br, dashed);

    void drawLabel(String text, Offset pos) {
      final tp = TextPainter(
        text: TextSpan(
            text: text,
            style: const TextStyle(
                color: cPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos);
    }

    drawLabel('a', Offset(size.width / 2 - 4, size.height - 14));
    drawLabel('t', Offset(size.width / 2 + 4, size.height / 2 - 8));
  }

  @override
  bool shouldRepaint(_) => false;
}
