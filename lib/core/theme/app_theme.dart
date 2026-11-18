import 'package:flutter/material.dart';

/// Tema pusat aplikasi.
class AppTheme {
  const AppTheme._();

  static const Color _seed = Color(0xFF7C5CFF);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _seed),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
      );
}