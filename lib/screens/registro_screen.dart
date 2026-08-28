import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/atividade.dart';
import '../models/alimentacao.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});
  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  bool _modoAtividade = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ToggleButtons(
            isSelected: [_modoAtividade, !_modoAtividade],
            onPressed: (i) => setState(() => _modoAtividade = i == 0),
            children: const [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text('Atividade', style: TextStyle(fontSize: 20))),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text('Alimentação', style: TextStyle(fontSize: 20))),
            ],
          ),
          const SizedBox(height: 20),
          _modoAtividade ? const _FormAtividade() : const _FormRefeicao(),
        ],
      ),
    );
  }
}

class _FormAtividade extends StatefulWidget {
  const _FormAtividade();
  @override
  State<_FormAtividade> createState() => _FormAtividadeState();
}

class _FormAtividadeState extends State<_FormAtividade> {
  TipoAtividade _tipo = TipoAtividade.aerobico;
  Intensidade _intensidade = Intensidade.leve;
  int _duracao = 20;
  int _sentimento = 3;

  Future<void> _salvar() async {
    final atv = Atividade(
      data: DateTime.now(),
      tipo: _tipo,
      duracaoMinutos: _duracao,
      intensidade: _intensidade,
      sentimento: _sentimento,
    );
    await DatabaseHelper.instance.inserirAtividade(atv);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Atividade registrada!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<TipoAtividade>(
          value: _tipo,
          decoration: const InputDecoration(
              labelText: 'Tipo', labelStyle: TextStyle(fontSize: 20)),
          items: TipoAtividade.values
              .map((t) => DropdownMenuItem(
                  value: t, child: Text(t.label, style: const TextStyle(fontSize: 20))))
              .toList(),
          onChanged: (v) => setState(() => _tipo = v!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<Intensidade>(
          value: _intensidade,
          decoration: const InputDecoration(
              labelText: 'Intensidade', labelStyle: TextStyle(fontSize: 20)),
          items: Intensidade.values
              .map((t) => DropdownMenuItem(
                  value: t, child: Text(t.label, style: const TextStyle(fontSize: 20))))
              .toList(),
          onChanged: (v) => setState(() => _intensidade = v!),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: '20',
          decoration: const InputDecoration(
              labelText: 'Duração (minutos)', labelStyle: TextStyle(fontSize: 20)),
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 20),
          onChanged: (v) => _duracao = int.tryParse(v) ?? 20,
        ),
        const SizedBox(height: 16),
        Text('Como você se sentiu? $_sentimento/5',
            style: const TextStyle(fontSize: 20)),
        Slider(
          value: _sentimento.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: _sentimento.toString(),
          onChanged: (v) => setState(() => _sentimento = v.toInt()),
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _salvar, child: const Text('Salvar atividade')),
      ],
    );
  }
}

class _FormRefeicao extends StatefulWidget {
  const _FormRefeicao();
  @override
  State<_FormRefeicao> createState() => _FormRefeicaoState();
}

class _FormRefeicaoState extends State<_FormRefeicao> {
  CategoriaAlimento _categoria = CategoriaAlimento.vegetais;
  final _descricao = TextEditingController();
  int _ml = 250;

  Future<void> _salvar() async {
    final r = Refeicao(
      data: DateTime.now(),
      categoria: _categoria,
      descricao: _descricao.text.isEmpty ? _categoria.label : _descricao.text,
      quantidadeMl: _categoria == CategoriaAlimento.agua ? _ml : 0,
    );
    await DatabaseHelper.instance.inserirRefeicao(r);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Refeição registrada!')));
      _descricao.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<CategoriaAlimento>(
          value: _categoria,
          decoration: const InputDecoration(
              labelText: 'Categoria', labelStyle: TextStyle(fontSize: 20)),
          items: CategoriaAlimento.values
              .map((t) => DropdownMenuItem(
                  value: t, child: Text(t.label, style: const TextStyle(fontSize: 20))))
              .toList(),
          onChanged: (v) => setState(() => _categoria = v!),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descricao,
          decoration: const InputDecoration(
              labelText: 'Descrição (opcional)', labelStyle: TextStyle(fontSize: 20)),
          style: const TextStyle(fontSize: 20),
        ),
        if (_categoria == CategoriaAlimento.agua) ...[
          const SizedBox(height: 16),
          TextFormField(
            initialValue: '250',
            decoration: const InputDecoration(
                labelText: 'Quantidade (ml)', labelStyle: TextStyle(fontSize: 20)),
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 20),
            onChanged: (v) => _ml = int.tryParse(v) ?? 0,
          ),
        ],
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _salvar, child: const Text('Salvar refeição')),
      ],
    );
  }
}
