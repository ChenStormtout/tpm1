import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';

class KelompokPage extends StatelessWidget {
  const KelompokPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Kelompok')),
      body: Column(
        children: [
          buildPageHeader(
              'Anggota Kelompok', '${kAnggota.length} orang terdaftar'),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: kAnggota.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final a = kAnggota[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cPrimary,
                      child: Text('${i + 1}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    title: Text(a['nama']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: cText)),
                    subtitle: Text('NIM: ${a['nim']!}',
                        style: const TextStyle(color: cTextLight)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
