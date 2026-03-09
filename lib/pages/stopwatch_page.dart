import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});
  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _sw = Stopwatch();
  Timer? _timer;
  final List<String> _laps = [];

  void _startStop() {
    if (_sw.isRunning) {
      _sw.stop();
      _timer?.cancel();
    } else {
      _sw.start();
      _timer = Timer.periodic(
          const Duration(milliseconds: 30), (_) => setState(() {}));
    }
    setState(() {});
  }

  void _reset() {
    _sw
      ..stop()
      ..reset();
    _timer?.cancel();
    setState(() => _laps.clear());
  }

  void _lap() {
    if (!_sw.isRunning) return;
    setState(() =>
        _laps.insert(0, 'Lap ${_laps.length + 1}  —  ${_fmt(_sw.elapsed)}'));
  }

  String _fmt(Duration d) {
    final min =
        d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec =
        d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final ms = (d.inMilliseconds.remainder(1000) ~/ 10)
        .toString()
        .padLeft(2, '0');
    return '$min:$sec.$ms';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch')),
      body: Column(
        children: [
          // Display waktu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [cPrimary, cPrimaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Column(children: [
              Text(
                _fmt(_sw.elapsed),
                style: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFeatures: [FontFeature.tabularFigures()],
                    letterSpacing: 2),
              ),
              const SizedBox(height: 6),
              Text(
                _sw.isRunning ? 'Berjalan...' : 'Dihentikan',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7), fontSize: 13),
              ),
            ]),
          ),
          // Tombol kontrol
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _startStop,
                  icon: Icon(_sw.isRunning
                      ? Icons.pause
                      : Icons.play_arrow),
                  label: Text(_sw.isRunning ? 'Pause' : 'Start'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _sw.isRunning ? cError : cPrimary),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _lap,
                  icon: const Icon(Icons.flag_outlined),
                  label: const Text('Lap'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: cAccent),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: cSurface,
                      foregroundColor: cText),
                ),
              ),
            ]),
          ),
          // Daftar lap
          if (_laps.isNotEmpty) ...[
            const Divider(height: 1),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Lap',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cText,
                        fontSize: 14)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _laps.length,
                itemBuilder: (_, i) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.flag_outlined,
                        color: cAccent, size: 20),
                    title: Text(_laps[i],
                        style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            color: cText)),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
