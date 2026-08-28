import 'dart:async';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/planejamento_service.dart';

// Tela "Plano": exibe o cronograma semanal personalizado com base no histórico.
class PlanoScreen extends StatefulWidget {
  const PlanoScreen({super.key});
  @override
  State<PlanoScreen> createState() => _PlanoScreenState();
}

class _PlanoScreenState extends State<PlanoScreen> {
  List<PlanoItem> _plano = [];
  bool _carregando = true;
  late final StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _carregar();
    // Atualiza o plano automaticamente quando o histórico muda.
    _sub = DatabaseHelper.instance.onChange.listen((_) => _carregar());
  }

  // Lê o histórico e gera o plano personalizado.
  Future<void> _carregar() async {
    final ativ = await DatabaseHelper.instance.listarAtividades();
    final ref = await DatabaseHelper.instance.listarRefeicoes();
    if (!mounted) return;
    setState(() {
      _plano = PlanejamentoService.gerarPlanoSemanal(ativ, ref);
      _carregando = false;
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Seu plano da semana',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Personalizado com base nos seus registros',
            style: TextStyle(fontSize: 18, color: Colors.grey)),
        const SizedBox(height: 16),
        // Um card por dia da semana, com o tipo de atividade e o detalhe.
        ..._plano.map((p) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  child: Text(p.dia,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                title: Text(p.atividade,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                subtitle: Text(p.detalhe, style: const TextStyle(fontSize: 18)),
              ),
            )),
      ],
    );
  }
}
