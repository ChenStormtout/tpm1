import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';
import 'login_page.dart';
import 'kelompok_page.dart';
import 'aritmatika_page.dart';
import 'bilangan_page.dart';
import 'total_angka_page.dart';
import 'stopwatch_page.dart';
import 'piramid_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _menus = [
    {
      'icon': Icons.people_alt_outlined,
      'label': 'Data Kelompok',
      'page': 'kelompok'
    },
    {
      'icon': Icons.calculate_outlined,
      'label': 'Penjumlahan &\nPengurangan',
      'page': 'aritmatika'
    },
    {
      'icon': Icons.filter_alt_outlined,
      'label': 'Ganjil/Genap\n& Prima',
      'page': 'bilangan'
    },
    {
      'icon': Icons.format_list_numbered_outlined,
      'label': 'Jumlah Total\nAngka',
      'page': 'total'
    },
    {
      'icon': Icons.timer_outlined,
      'label': 'Stopwatch',
      'page': 'stopwatch'
    },
    {
      'icon': Icons.architecture_outlined,
      'label': 'Luas & Volume\nPiramid',
      'page': 'piramid'
    },
  ];

  void _navigate(BuildContext context, String page) {
    final pages = {
      'kelompok': const KelompokPage(),
      'aritmatika': const AritmatikaPage(),
      'bilangan': const BilanganPage(),
      'total': const TotalAngkaPage(),
      'stopwatch': const StopwatchPage(),
      'piramid': const PiramidPage(),
    };
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => pages[page]!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const LoginPage())),
          )
        ],
      ),
      body: Column(
        children: [
          buildPageHeader(
              'Selamat Datang', 'Pilih menu yang tersedia di bawah ini'),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: _menus.length,
              itemBuilder: (context, i) {
                final m = _menus[i];
                return _MenuCard(
                  icon: m['icon'] as IconData,
                  label: m['label'] as String,
                  onTap: () => _navigate(context, m['page'] as String),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuCard(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: cPrimary),
              ),
              const SizedBox(height: 12),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cText,
                      height: 1.3)),
            ],
          ),
        ),
      ),
    );
  }
}
