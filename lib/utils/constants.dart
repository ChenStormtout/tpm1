import 'package:flutter/material.dart';

// ─── CONFIG: Ganti sesuai kelompok ───────────────────────────
const String kUsername = 'rafitampan';
const String kPassword = 'rafitampan';

const List<Map<String, String>> kAnggota = [
  {'nama': 'Dewa Setya Bagus ', 'nim': '123230063'},
  {'nama': 'Rafi', 'nim': '1232300'},
  {'nama': 'Star', 'nim': '1232300'},
  {'nama': 'Anggota Empat', 'nim': '123230066'},
];
// ─────────────────────────────────────────────────────────────

// ─── COLORS ──────────────────────────────────────────────────
const Color cBg = Color(0xFFF4F1EB);
const Color cSurface = Color(0xFFEAE5D8);
const Color cPrimary = Color(0xFF3D6B4F);
const Color cPrimaryDark = Color(0xFF2A4D38);
const Color cAccent = Color(0xFF8FAF6A);
const Color cText = Color(0xFF1E2D22);
const Color cTextLight = Color(0xFF5A6B5E);
const Color cCard = Color(0xFFFFFFFA);
const Color cError = Color(0xFFB85C3A);
// ─────────────────────────────────────────────────────────────

// ─── THEME ───────────────────────────────────────────────────
ThemeData get appTheme => ThemeData(
      scaffoldBackgroundColor: cBg,
      colorScheme: const ColorScheme.light(
        primary: cPrimary,
        secondary: cAccent,
        surface: cSurface,
        error: cError,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cPrimary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cAccent.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cPrimary, width: 2),
        ),
        labelStyle: const TextStyle(color: cTextLight),
        prefixIconColor: cPrimary,
      ),
      cardTheme: CardThemeData(
        color: cCard,
        elevation: 2,
        shadowColor: cPrimary.withValues(alpha: 0.1),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );