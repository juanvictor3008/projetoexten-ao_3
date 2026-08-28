import '../models/atividade.dart';
import '../models/alimentacao.dart';

class Sugestao {
  final String texto;
  final int prioridade; // 1 alta, 2 media, 3 baixa
  Sugestao({required this.texto, required this.prioridade});
}

class SugestaoService {
  static const int metaMinutosSemana = 150;
  static const int metaForcaSemana = 2;
  static const int metaEquilibrioSemana = 2;
  static const int metaAguaMlDia = 1500;

  static List<Sugestao> gerar(List<Atividade> atividades, List<Refeicao> refeicoes) {
    final agora = DateTime.now();
    final inicioSemana = agora.subtract(const Duration(days: 7));

    final ativSemana = atividades.where((a) => a.data.isAfter(inicioSemana)).toList();
    final refSemana = refeicoes.where((r) => r.data.isAfter(inicioSemana)).toList();

    final minutos = ativSemana.fold<int>(0, (s, a) => s + a.duracaoMinutos);
    final forcas = ativSemana.where((a) => a.tipo == TipoAtividade.forca).length;
    final equilibrios = ativSemana.where((a) => a.tipo == TipoAtividade.equilibrio).length;

    final diasComAgua = refSemana
        .where((r) => r.categoria == CategoriaAlimento.agua && r.quantidadeMl >= metaAguaMlDia)
        .map((r) => DateTime(r.data.year, r.data.month, r.data.day))
        .toSet();
    final diasVegetais = refSemana
        .where((r) => r.categoria == CategoriaAlimento.vegetais)
        .map((r) => DateTime(r.data.year, r.data.month, r.data.day))
        .toSet();

    final sugestoes = <Sugestao>[];

    if (minutos < metaMinutosSemana) {
      final faltam = metaMinutosSemana - minutos;
      sugestoes.add(Sugestao(
        texto:
            'Você fez $minutos min esta semana. Faltam $faltam min para a meta de $metaMinutosSemana min. Que tal uma caminhada leve de 20 min?',
        prioridade: 1,
      ));
    }
    if (forcas < metaForcaSemana) {
      sugestoes.add(Sugestao(
        texto:
            'Exercícios de força ajudam a evitar quedas. Planeje $metaForcaSemana por semana (ex: levantar de uma cadeira).',
        prioridade: 1,
      ));
    }
    if (equilibrios < metaEquilibrioSemana) {
      sugestoes.add(Sugestao(
        texto:
            'Treino de equilíbrio (${metaEquilibrioSemana}x/sem) reduz risco de quedas. Tente ficar em 1 pé por 10 seg.',
        prioridade: 2,
      ));
    }
    if (diasComAgua.length < 5) {
      sugestoes.add(Sugestao(
        texto:
            'Beba água durante o dia. Você atingiu a meta em ${diasComAgua.length} dias esta semana.',
        prioridade: 2,
      ));
    }
    if (diasVegetais.length < 5) {
      sugestoes.add(Sugestao(
        texto:
            'Inclua vegetais ou frutas todo dia. Registrados em ${diasVegetais.length} dias esta semana.',
        prioridade: 3,
      ));
    }
    if (sugestoes.isEmpty) {
      sugestoes.add(Sugestao(
        texto: 'Parabéns! Você está dentro das metas. Continue assim para manter sua saúde.',
        prioridade: 3,
      ));
    }
    sugestoes.sort((a, b) => a.prioridade.compareTo(b.prioridade));
    return sugestoes;
  }
}
