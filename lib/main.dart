import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_page.dart';

// Ponto de entrada do aplicativo: o Flutter executa esta função ao iniciar.
void main() {
  // Cria e exibe o widget raiz do app.
  runApp(const MovimentaApp());
}

// Widget raiz que configura o tema e a tela inicial do aplicativo.
class MovimentaApp extends StatelessWidget {
  const MovimentaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp define a estrutura base (tema, rotas e app bar).
    return MaterialApp(
      title: 'Movimenta',
      theme: AppTheme.lightTheme, // aplica o tema acessível de app_theme.dart
      home: const HomePage(), // tela inicial com a navegação por abas
      debugShowCheckedModeBanner: false, // remove a faixa "Debug" no canto
    );
  }
}
