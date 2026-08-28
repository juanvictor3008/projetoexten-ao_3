import 'dart:async';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/atividade.dart';
import '../models/alimentacao.dart';

// Tela "Histórico": lista tudo que foi registrado e permite excluir.
class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});
  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  List<Atividade> _ativ = [];
  List<Refeicao> _ref = [];
  bool _carregando = true;
  late final StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _carregar();
    // Atualiza a lista quando algo é registrado ou excluído.
    _sub = DatabaseHelper.instance.onChange.listen((_) => _carregar());
  }

  // Lê atividades e refeições salvas.
  Future<void> _carregar() async {
    final a = await DatabaseHelper.instance.listarAtividades();
    final r = await DatabaseHelper.instance.listarRefeicoes();
    if (!mounted) return;
    setState(() {
      _ativ = a;
      _ref = r;
      _carregando = false;
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  // Formata data/hora para exibição curta.
  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    final itens = <Widget>[];
    // Card de cada atividade física, com botão de excluir.
    for (final a in _ativ) {
      itens.add(Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: const Icon(Icons.directions_run, size: 32, color: Colors.green),
          title: Text('${a.tipo.label} • ${a.duracaoMinutos} min',
              style: const TextStyle(fontSize: 20)),
          subtitle: Text(
              '${a.intensidade.label} • sentiu ${a.sentimento}/5 (${labelSentimento(a.sentimento)}) • ${_fmt(a.data)}',
              style: const TextStyle(fontSize: 16)),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => DatabaseHelper.instance.excluirAtividade(a.id!),
          ),
        ),
      ));
    }
    // Card de cada refeição, com botão de excluir.
    for (final r in _ref) {
      final detalhe =
          r.categoria == CategoriaAlimento.agua ? '${r.quantidadeMl} ml' : r.descricao;
      itens.add(Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: const Icon(Icons.restaurant, size: 32, color: Colors.orange),
          title: Text(r.categoria.label, style: const TextStyle(fontSize: 20)),
          subtitle: Text('$detalhe • ${_fmt(r.data)}', style: const TextStyle(fontSize: 16)),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => DatabaseHelper.instance.excluirRefeicao(r.id!),
          ),
        ),
      ));
    }
    if (itens.isEmpty) {
      return const Center(
          child: Text('Nenhum registro ainda.', style: TextStyle(fontSize: 22)));
    }
    return ListView(padding: const EdgeInsets.all(16), children: itens);
  }
}
