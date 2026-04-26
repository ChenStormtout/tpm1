import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';

class SakaPage extends StatefulWidget {
  const SakaPage({super.key});

  @override
  State<SakaPage> createState() => _SakaPageState();
}

class _SakaPageState extends State<SakaPage> {
  DateTime? _selectedDate;
  String _hasilSaka = '';
  String _keterangan = '';
  bool _isError = false;

  static final DateTime _firstDate = DateTime(1000);
  static final DateTime _lastDate = DateTime(3000);

  Future<void> _pilihTanggal() async {
    try {
      final picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: _firstDate,
        lastDate: _lastDate,
        helpText: 'Pilih Tanggal Masehi',
        cancelText: 'Batal',
        confirmText: 'Pilih',
      );

      if (picked == null || !mounted) return;

      _konversiKeSaka(picked);
    } catch (e) {
      _tampilkanError('Terjadi kesalahan saat memilih tanggal.');
    }
  }

  void _tanggalHariIni() {
    _konversiKeSaka(DateTime.now());
  }

  void _konversiKeSaka(DateTime tanggal) {
    try {
      final hasil = _hitungSaka(tanggal);

      setState(() {
        _selectedDate = tanggal;
        _hasilSaka =
            '${hasil.hari} ${hasil.namaBulan} ${hasil.tahun} Saka';
        _keterangan = _getKeteranganBulan(hasil.bulan);
        _isError = false;
      });
    } catch (e) {
      setState(() {
        _selectedDate = tanggal;
        _hasilSaka = 'Tanggal tidak dapat dikonversi.';
        _keterangan =
            'Terjadi kesalahan dalam proses perhitungan kalender Saka.';
        _isError = true;
      });

      _tampilkanError('Gagal mengonversi tanggal ke kalender Saka.');
    }
  }

  _SakaResult _hitungSaka(DateTime date) {
    if (date.year < 1) {
      throw Exception('Tahun tidak valid');
    }

    final bool leap = _isGregorianLeapYear(date.year);

    final DateTime awalSaka = DateTime(
      date.year,
      3,
      leap ? 21 : 22,
    );

    int tahunSaka;
    DateTime awalTahunSaka;

    if (!date.isBefore(awalSaka)) {
      tahunSaka = date.year - 78;
      awalTahunSaka = awalSaka;
    } else {
      final bool leapPrev = _isGregorianLeapYear(date.year - 1);
      tahunSaka = date.year - 79;
      awalTahunSaka = DateTime(
        date.year - 1,
        3,
        leapPrev ? 21 : 22,
      );
    }

    final int selisihHari = date.difference(awalTahunSaka).inDays;

    if (selisihHari < 0) {
      throw Exception('Selisih hari tidak valid');
    }

    final List<int> panjangBulan = [
      _isGregorianLeapYear(awalTahunSaka.year) ? 31 : 30,
      31,
      31,
      31,
      31,
      31,
      30,
      30,
      30,
      30,
      30,
      30,
    ];

    int bulan = 1;
    int sisaHari = selisihHari;

    for (int i = 0; i < panjangBulan.length; i++) {
      if (sisaHari < panjangBulan[i]) {
        bulan = i + 1;
        break;
      }
      sisaHari -= panjangBulan[i];
    }

    final int hari = sisaHari + 1;

    if (bulan < 1 || bulan > 12 || hari < 1 || hari > 31) {
      throw Exception('Hasil kalender Saka tidak valid');
    }

    return _SakaResult(
      hari: hari,
      bulan: bulan,
      namaBulan: _namaBulanSaka(bulan),
      tahun: tahunSaka,
    );
  }

  bool _isGregorianLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  String _namaBulanSaka(int bulan) {
    const namaBulan = [
      '',
      'Caitra',
      'Waisaka',
      'Jyesta',
      'Asadha',
      'Srawana',
      'Bhadrapada',
      'Asuji',
      'Kartika',
      'Margasira',
      'Posya',
      'Magha',
      'Phalguna',
    ];

    if (bulan < 1 || bulan > 12) {
      return 'Bulan Tidak Diketahui';
    }

    return namaBulan[bulan];
  }

  String _getKeteranganBulan(int bulan) {
    switch (bulan) {
      case 1:
        return 'Caitra - Bulan pertama dalam kalender Saka.';
      case 2:
        return 'Waisaka - Bulan kedua dalam kalender Saka.';
      case 3:
        return 'Jyesta - Bulan ketiga dalam kalender Saka.';
      case 4:
        return 'Asadha - Bulan keempat dalam kalender Saka.';
      case 5:
        return 'Srawana - Bulan kelima dalam kalender Saka.';
      case 6:
        return 'Bhadrapada - Bulan keenam dalam kalender Saka.';
      case 7:
        return 'Asuji - Bulan ketujuh dalam kalender Saka.';
      case 8:
        return 'Kartika - Bulan kedelapan dalam kalender Saka.';
      case 9:
        return 'Margasira - Bulan kesembilan dalam kalender Saka.';
      case 10:
        return 'Posya - Bulan kesepuluh dalam kalender Saka.';
      case 11:
        return 'Magha - Bulan kesebelas dalam kalender Saka.';
      case 12:
        return 'Phalguna - Bulan terakhir dalam kalender Saka.';
      default:
        return 'Bulan Saka tidak dikenali.';
    }
  }

  String _formatMasehi(DateTime date) {
    try {
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return DateFormat('EEEE, dd MMMM yyyy').format(date);
    }
  }

  void _tampilkanError(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasResult = _selectedDate != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Saka'),
      ),
      body: Column(
        children: [
          buildPageHeader(
            'Masehi ke Saka',
            'Konversi penanggalan Masehi ke kalender Saka',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _pilihTanggal,
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Pilih Tanggal Masehi'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _tanggalHariIni,
                      icon: const Icon(Icons.today),
                      label: const Text('Gunakan Tanggal Hari Ini'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (hasResult) ...[
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              'Tanggal Masehi',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatMasehi(_selectedDate!),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    ResultCard(
                      label: _isError ? 'Konversi Gagal:' : 'Kalender Saka:',
                      value: _hasilSaka,
                      color: _isError ? Colors.red : cAccent,
                    ),

                    const SizedBox(height: 16),

                    Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              _isError
                                  ? Icons.error_outline
                                  : Icons.info_outline,
                              color: _isError ? Colors.red : cAccent,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _keterangan,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Catatan: Konversi ini menggunakan pendekatan kalender Saka berbasis perhitungan. Kalender tradisional daerah tertentu dapat memiliki perbedaan dalam praktik penggunaannya.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.4,
                      ),
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

class _SakaResult {
  final int hari;
  final int bulan;
  final String namaBulan;
  final int tahun;

  _SakaResult({
    required this.hari,
    required this.bulan,
    required this.namaBulan,
    required this.tahun,
  });
}