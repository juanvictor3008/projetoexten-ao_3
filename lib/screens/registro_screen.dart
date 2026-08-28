import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/atividade.dart';
import '../models/alimentacao.dart';

// Tela "Registrar": permite cadastrar atividades físicas ou alimentação.
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});
  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  bool _modoAtividade = true; // true = form de atividade; false = form de refeição

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Botões de alternância entre os dois tipos de registro.
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
          // Exibe o formulário correspondente à opção escolhida.
          _modoAtividade ? const _FormAtividade() : const _FormRefeicao(),
        ],
      ),
    );
  }
}

// Formulário de registro de atividade física.
class _FormAtividade extends StatefulWidget {
  const _FormAtividade();
  @override
  State<_FormAtividade> createState() => _FormAtividadeState();
}

class _FormAtividadeState extends State<_FormAtividade> {
  // Valores atuais dos campos do formulário.
  TipoAtividade _tipo = TipoAtividade.aerobico;
  Intensidade _intensidade = Intensidade.leve;
  int _duracao = 20;
  int _sentimento = 3;

  // Cria o objeto Atividade e salva na persistência local.
  Future<void> _salvar() async {
    final atv = Atividade(
      data: DateTime.now(),
      tipo: _tipo,
      duracaoMinutos: _duracao,
      intensidade: _intensidade,
      sentimento: _sentimento,
    );
    await DatabaseHelper.instance.inserirAtividade(atv);
    // Confirma para o usuário, se a tela ainda estiver ativa.
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Atividade registrada!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Seleção do tipo de atividade.
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
        // Seleção da intensidade.
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
        // Duração em minutos (entrada numérica).
        TextFormField(
          initialValue: '20',
          decoration: const InputDecoration(
              labelText: 'Duração (minutos)', labelStyle: TextStyle(fontSize: 20)),
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 20),
          onChanged: (v) => _duracao = int.tryParse(v) ?? 20,
        ),
        const SizedBox(height: 16),
        // Sentimento pós-atividade (1 a 5): deixa claro o que cada número significa.
        Text('Como você se sentiu depois da atividade?',
            style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        // Mostra o valor atual já traduzido para texto.
        Text('$_sentimento/5 — ${labelSentimento(_sentimento)}',
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
        Slider(
          value: _sentimento.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: _sentimento.toString(),
          onChanged: (v) => setState(() => _sentimento = v.toInt()),
        ),
        // Legenda completa para o idoso não se perder na escala.
        const Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            Text('1 = Muito mal', style: TextStyle(fontSize: 15)),
            Text('2 = Mal', style: TextStyle(fontSize: 15)),
            Text('3 = Mais ou menos', style: TextStyle(fontSize: 15)),
            Text('4 = Bem', style: TextStyle(fontSize: 15)),
            Text('5 = Muito bem', style: TextStyle(fontSize: 15)),
          ],
        ),
        const SizedBox(height: 20),
        // Botão que dispara o salvamento.
        ElevatedButton(onPressed: _salvar, child: const Text('Salvar atividade')),
      ],
    );
  }
}

// Formulário de registro de alimentação.
class _FormRefeicao extends StatefulWidget {
  const _FormRefeicao();
  @override
  State<_FormRefeicao> createState() => _FormRefeicaoState();
}

class _FormRefeicaoState extends State<_FormRefeicao> {
  CategoriaAlimento _categoria = CategoriaAlimento.vegetais;
  final _descricao = TextEditingController();
  int _ml = 250; // quantidade de água, usada só quando a categoria é "Água"

  // Cria o objeto Refeicao e salva na persistência local.
  Future<void> _salvar() async {
    final r = Refeicao(
      data: DateTime.now(),
      categoria: _categoria,
      // Se não escreveu descrição, usa o nome da categoria.
      descricao: _descricao.text.isEmpty ? _categoria.label : _descricao.text,
      // Só registra ml se for água; senão fica 0.
      quantidadeMl: _categoria == CategoriaAlimento.agua ? _ml : 0,
    );
    await DatabaseHelper.instance.inserirRefeicao(r);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Refeição registrada!')));
      _descricao.clear(); // limpa o campo após salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Seleção da categoria do alimento.
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
        // Descrição livre (opcional).
        TextFormField(
          controller: _descricao,
          decoration: const InputDecoration(
              labelText: 'Descrição (opcional)', labelStyle: TextStyle(fontSize: 20)),
          style: const TextStyle(fontSize: 20),
        ),
        // Campo de ml aparece somente para a categoria "Água".
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
