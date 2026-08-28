import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../database/database_helper.dart';
import '../models/atividade.dart';
import '../models/alimentacao.dart';
import '../services/sugestao_service.dart';

// Tela "Modo Cuidador": mostra um resumo do idoso e permite enviar um
// relatório (offline) via WhatsApp/e-mail, sem servidor na nuvem.
class CuidadorScreen extends StatefulWidget {
  const CuidadorScreen({super.key});
  @override
  State<CuidadorScreen> createState() => _CuidadorScreenState();
}

class _CuidadorScreenState extends State<CuidadorScreen> {
  String _nome = '';
  final _nomeCtrl = TextEditingController();
  List<Atividade> _ativ = [];
  List<Refeicao> _ref = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  // Lê o nome salvo e o histórico para montar o resumo.
  Future<void> _carregar() async {
    final db = DatabaseHelper.instance;
    final nome = await db.lerNome();
    final ativ = await db.listarAtividades();
    final ref = await db.listarRefeicoes();
    if (!mounted) return;
    setState(() {
      _nome = nome;
      _nomeCtrl.text = nome;
      _ativ = ativ;
      _ref = ref;
      _carregando = false;
    });
  }

  // Salva o nome do idoso no dispositivo.
  Future<void> _salvarNome() async {
    await DatabaseHelper.instance.salvarNome(_nomeCtrl.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Perfil salvo!')));
    }
  }

  // Monta o texto do relatório que será compartilhado com o cuidador.
  String _relatorio() {
    final sugestoes = SugestaoService.gerar(_ativ, _ref);
    final buffer = StringBuffer();
    buffer.writeln('Relatório de atividade — Movimenta');
    buffer.writeln('Idoso: ${_nome.isEmpty ? "(sem nome)" : _nome}');
    buffer.writeln('Atividades registradas: ${_ativ.length}');
    buffer.writeln('Refeições registradas: ${_ref.length}');
    buffer.writeln('');
    buffer.writeln('Sugestões:');
    for (final s in sugestoes) {
      buffer.writeln('- ${s.texto}');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar:
          AppBar(title: const Text('Modo Cuidador', style: TextStyle(fontSize: 24))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Nome do idoso (para o relatório)',
              style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          // Campo para definir o nome exibido no relatório.
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nomeCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Nome', labelStyle: TextStyle(fontSize: 20)),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _salvarNome, child: const Text('Salvar')),
            ],
          ),
          const SizedBox(height: 20),
          // Resumo rápido do acompanhamento.
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Resumo',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Atividades registradas: ${_ativ.length}',
                      style: const TextStyle(fontSize: 20)),
                  Text('Refeições registradas: ${_ref.length}',
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Botão que abre o compartilhamento do sistema (WhatsApp/e-mail).
          ElevatedButton.icon(
            onPressed: () => Share.share(_relatorio()),
            icon: const Icon(Icons.share),
            label: const Text('Enviar relatório (WhatsApp/e-mail)'),
          ),
        ],
      ),
    );
  }
}
