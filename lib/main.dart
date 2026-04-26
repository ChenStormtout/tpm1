import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // TAMBAHAN
import 'utils/constants.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // TAMBAHAN

  await initializeDateFormatting('id_ID', null); // TAMBAHAN

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Mobile',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const LoginPage(),
    );
  }
}