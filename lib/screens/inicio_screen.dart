import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/sugestao_service.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});
  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  List<Sugestao> _sugestoes = [];
  int _minutosSemana = 0;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final db = DatabaseHelper.instance;
    final ativ = await db.listarAtividades();
    final ref = await db.listarRefeicoes();
    final agora = DateTime.now();
    final inicio = agora.subtract(const Duration(days: 7));
    final minutos = ativ
        .where((a) => a.data.isAfter(inicio))
        .fold<int>(0, (s, a) => s + a.duracaoMinutos);
    setState(() {
      _sugestoes = SugestaoService.gerar(ativ, ref);
      _minutosSemana = minutos;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
