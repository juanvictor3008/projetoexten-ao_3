import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/sugestao_service.dart';

// Tela "Início": mostra o progresso da semana e as sugestões personalizadas.
class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});
  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  List<Sugestao> _sugestoes = [];
  int _minutosSemana = 0;
  bool _carregando = true; // controla a tela de carregamento

  @override
  void initState() {
    super.initState();
    // Ao abrir a tela, já busca os dados e gera as sugestões.
    _carregar();
  }

  // Lê os registros salvos, calcula o total da semana e monta as sugestões.
  Future<void> _carregar() async {
    final db = DatabaseHelper.instance;
    final ativ = await db.listarAtividades();
    final ref = await db.listarRefeicoes();

    // Período considerado "esta semana" (últimos 7 dias).
    final agora = DateTime.now();
    final inicio = agora.subtract(const Duration(days: 7));

    // Soma os minutos de atividade registrados na última semana.
    final minutos = ativ
        .where((a) => a.data.isAfter(inicio))
        .fold<int>(0, (s, a) => s + a.duracaoMinutos);

    setState(() {
      _sugestoes = SugestaoService.gerar(ativ, ref);
      _minutosSemana = minutos;
      _carregando = false; // libera a exibição da tela
    });
  }

  @override
  Widget build(BuildContext context) {
    // Enquanto carrega, mostra um indicador de progresso.
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      // Puxar para atualizar recarrega os dados.
      onRefresh: _carregar,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card com o progresso de minutos na semana.
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Seu progresso esta semana',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('$_minutosSemana de 150 min de atividade',
                      style: const TextStyle(fontSize: 24)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Sugestões para você',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          // Lista as sugestões; ícone vermelho indica prioridade alta.
          ..._sugestoes.map((s) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    s.prioridade == 1 ? Icons.priority_high : Icons.lightbulb_outline,
                    size: 36,
                    color: s.prioridade == 1 ? Colors.red : Colors.green,
                  ),
                  title: Text(s.texto, style: const TextStyle(fontSize: 20)),
                ),
              )),
        ],
      ),
    );
  }
}
