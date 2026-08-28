import 'package:flutter/material.dart';

// Centraliza as definições visuais do app, pensadas para idosos:
// fontes grandes, bom contraste e botões confortáveis de tocar.
class AppTheme {
  // Cores principais (verde remete à saúde; amarelo destaca ações).
  static const Color primary = Color(0xFF2E7D32);
  static const Color secondary = Color(0xFFF9A825);
  static const Color background = Color(0xFFF5F5F0);
  static const Color textDark = Color(0xFF1B1B1B);

  // Tema claro usado em todo o app.
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      background: background,
    ),
    // Tamanhos de fonte aumentados para facilitar a leitura.
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
      displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textDark),
      bodyLarge: TextStyle(fontSize: 22, color: textDark),
      bodyMedium: TextStyle(fontSize: 20, color: textDark),
      labelLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    ),
    // Botões ocupam a largura toda e têm altura confortável (menos erro de toque).
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        textStyle: const TextStyle(fontSize: 22),
      ),
    ),
    // Rótulos da barra de navegação um pouco maiores.
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 16),
    ),
    useMaterial3: true,
  );
}
