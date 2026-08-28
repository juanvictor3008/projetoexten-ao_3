import 'package:flutter/material.dart';
import 'inicio_screen.dart';
import 'registro_screen.dart';
import 'plano_screen.dart';
import 'evolucao_screen.dart';

// Tela principal: mantém a navegação entre as 4 seções do app.
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indice = 0; // aba atualmente selecionada

  // As quatro telas acessíveis pela barra inferior.
  final telas = const [
    InicioScreen(),
    RegistroScreen(),
    PlanoScreen(),
    EvolucaoScreen(),
  ];
  final rotulos = const ['Início', 'Registrar', 'Plano', 'Evolução'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // O título muda conforme a aba selecionada.
        title: Text(rotulos[_indice], style: const TextStyle(fontSize: 24)),
      ),
      // Exibe a tela correspondente à aba atual.
      body: telas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        // Ao tocar em uma aba, atualiza o estado e troca a tela.
        onTap: (i) => setState(() => _indice = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Registrar'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Plano'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Evolução'),
        ],
      ),
    );
  }
}
