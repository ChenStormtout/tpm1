import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk FilteringTextInputFormatter
import '../utils/constants.dart';
import '../widgets/widgets.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _isRunning = false;
  final List<String> _laps = [];
  DateTime? _startTime;

  // Controller untuk Input Manual
  final _hController = TextEditingController();
  final _mController = TextEditingController();
  final _sController = TextEditingController();

  void _startStop() {
    setState(() {
      if (_isRunning) {
        _isRunning = false;
        _timer?.cancel();
      } else {
        _isRunning = true;
        _startTime = DateTime.now().subtract(_elapsed);
        _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
          setState(() {
            _elapsed = DateTime.now().difference(_startTime!);
          });
        });
      }
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _elapsed = Duration.zero;
      _laps.clear();
    });
  }

  void _lap() {
    if (_elapsed == Duration.zero) return;
    setState(() {
      _laps.insert(0, 'Lap ${_laps.length + 1}  —  ${_fmt(_elapsed)}');
    });
  }

  // FUNGSI BARU: Input Manual via Dialog
  void _showManualInputDialog() {
    if (_isRunning) return;

    // Set nilai awal di TextField sesuai waktu saat ini
    _hController.text = _elapsed.inHours.toString();
    _mController.text = _elapsed.inMinutes.remainder(60).toString();
    _sController.text = _elapsed.inSeconds.remainder(60).toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Waktu Manual', style: TextStyle(color: cPrimary)),
        content: Row(
          children: [
            _buildInputField(_hController, 'Jam'),
            const SizedBox(width: 8),
            _buildInputField(_mController, 'Menit'),
            const SizedBox(width: 8),
            _buildInputField(_sController, 'Detik'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: cPrimary),
            onPressed: () {
              setState(() {
                int h = int.tryParse(_hController.text) ?? 0;
                int m = int.tryParse(_mController.text) ?? 0;
                int s = int.tryParse(_sController.text) ?? 0;
                _elapsed = Duration(hours: h, minutes: m, seconds: s);
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
      ),
    );
  }

  String _fmt(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = d.inHours.toString();
    final min = twoDigits(d.inMinutes.remainder(60));
    final sec = twoDigits(d.inSeconds.remainder(60));
    final ms = (d.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    
    return d.inHours > 0 ? '$hours:$min:$sec.$ms' : '$min:$sec.$ms';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hController.dispose();
    _mController.dispose();
    _sController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: _isRunning ? null : _showManualInputDialog,
            tooltip: 'Set Manual',
          )
        ],
      ),
      body: Column(
        children: [
          buildPageHeader(
            'Penghitung Waktu', 
            _isRunning ? 'Sedang berjalan...' : 'Tekan angka untuk edit manual'
          ),
          
          // Display Waktu (Bisa di-klik untuk edit)
          InkWell(
            onTap: _isRunning ? null : _showManualInputDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                _fmt(_elapsed),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: cPrimary,
                  fontFeatures: [FontFeature.tabularFigures()],
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          // Tombol Kontrol
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _actionBtn(
                  label: _isRunning ? 'Pause' : 'Start',
                  icon: _isRunning ? Icons.pause : Icons.play_arrow,
                  color: _isRunning ? cError : cPrimary,
                  onTap: _startStop,
                ),
                const SizedBox(width: 12),
                _actionBtn(
                  label: 'Lap',
                  icon: Icons.flag_outlined,
                  color: cAccent,
                  onTap: _lap,
                ),
                const SizedBox(width: 12),
                _actionBtn(
                  label: 'Reset',
                  icon: Icons.refresh,
                  color: Colors.grey,
                  onTap: _reset,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          if (_laps.isNotEmpty) const Divider(height: 1),

          // List Lap
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _laps.length,
              itemBuilder: (context, i) => Card(
                elevation: 0,
                color: cSurface,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  dense: true,
                  leading: Text('#${_laps.length - i}', style: const TextStyle(color: cPrimary, fontWeight: FontWeight.bold)),
                  title: Text(
                    _laps[i].split('—')[1].trim(),
                    style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(children: [Icon(icon, size: 20), Text(label, style: const TextStyle(fontSize: 12))]),
      ),
    );
  }
}