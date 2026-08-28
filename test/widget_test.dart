import 'package:flutter_test/flutter_test.dart';
import 'package:movimenta/services/sugestao_service.dart';
import 'package:movimenta/services/planejamento_service.dart';
import 'package:movimenta/models/atividade.dart';
import 'package:movimenta/models/alimentacao.dart';

// Monta uma atividade de exemplo ocorrida `diaAtras` dias atrás.
Atividade ativ(TipoAtividade t, int min, int sent, int diaAtras) => Atividade(
      id: 1,
      data: DateTime.now().subtract(Duration(days: diaAtras)),
      tipo: t,
      duracaoMinutos: min,
      intensidade: Intensidade.leve,
      sentimento: sent,
    );

void main() {
  test('SugestaoService gera alerta quando sentimento esta baixo', () {
    // Maria sentiu-se mal (2/5) nas duas atividades da semana.
    final a = [
      ativ(TipoAtividade.aerobico, 20, 2, 1),
      ativ(TipoAtividade.aerobico, 20, 2, 2),
    ];
    final s = SugestaoService.gerar(a, []);
    expect(s.any((x) => x.prioridade == 1 && x.texto.contains('desconfortável')), isTrue);
    print('--- SUGESTOES (sentimento baixo) ---');
    for (final x in s) print('[${x.prioridade}] ${x.texto}');
  });

  test('PlanejamentoService personaliza os dias conforme o historico', () {
    // Semana com pouca atividade e sem força/equilíbrio registrados.
    final a = [
      ativ(TipoAtividade.aerobico, 20, 4, 1),
      ativ(TipoAtividade.aerobico, 20, 4, 2),
    ];
    final plano = PlanejamentoService.gerarPlanoSemanal(a, []);
    print('--- PLANO PERSONALIZADO ---');
    for (final p in plano) print('${p.dia}: ${p.atividade} | ${p.detalhe}');
    // Deve incluir Força e Equilíbrio por causa do débito da semana.
    expect(plano.any((p) => p.atividade == 'Força'), isTrue);
    expect(plano.any((p) => p.atividade == 'Equilíbrio'), isTrue);
  });
}
