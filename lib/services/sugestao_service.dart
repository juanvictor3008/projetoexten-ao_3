import '../models/atividade.dart';
import '../models/alimentacao.dart';

// Representa uma sugestão exibida ao usuário, com seu texto e prioridade.
class Sugestao {
  final String texto;
  final int prioridade; // 1 = alta, 2 = média, 3 = baixa
  Sugestao({required this.texto, required this.prioridade});
}

// Motor de regras que gera sugestões a partir dos registros do usuário.
// As metas seguem orientações de saúde para idosos (ex.: OMS).
class SugestaoService {
  // Metas semanais usadas como referência para as dicas.
  static const int metaMinutosSemana = 150; // atividade moderada por semana
  static const int metaForcaSemana = 2; // sessões de força por semana
  static const int metaEquilibrioSemana = 2; // sessões de equilíbrio por semana
  static const int metaAguaMlDia = 1500; // hidratação diária desejada

  // Analisa os registros dos últimos 7 dias e devolve a lista de sugestões.
  static List<Sugestao> gerar(List<Atividade> atividades, List<Refeicao> refeicoes) {
    final agora = DateTime.now();
    final inicioSemana = agora.subtract(const Duration(days: 7));

    // Filtra apenas o que foi registrado na última semana.
    final ativSemana = atividades.where((a) => a.data.isAfter(inicioSemana)).toList();
    final refSemana = refeicoes.where((r) => r.data.isAfter(inicioSemana)).toList();

    // Soma os minutos de atividade e conta os tipos relevantes.
    final minutos = ativSemana.fold<int>(0, (s, a) => s + a.duracaoMinutos);
    final forcas = ativSemana.where((a) => a.tipo == TipoAtividade.forca).length;
    final equilibrios = ativSemana.where((a) => a.tipo == TipoAtividade.equilibrio).length;

    // Conta os dias em que a pessoa atingiu a meta de água e de vegetais.
    final diasComAgua = refSemana
        .where((r) => r.categoria == CategoriaAlimento.agua && r.quantidadeMl >= metaAguaMlDia)
        .map((r) => DateTime(r.data.year, r.data.month, r.data.day))
        .toSet();
    final diasVegetais = refSemana
        .where((r) => r.categoria == CategoriaAlimento.vegetais)
        .map((r) => DateTime(r.data.year, r.data.month, r.data.day))
        .toSet();

    final sugestoes = <Sugestao>[];

    // Se ficou abaixo da meta de minutos, sugere atividade aeróbica leve.
    if (minutos < metaMinutosSemana) {
      final faltam = metaMinutosSemana - minutos;
      sugestoes.add(Sugestao(
        texto:
            'Você fez $minutos min esta semana. Faltam $faltam min para a meta de $metaMinutosSemana min. Que tal uma caminhada leve de 20 min?',
        prioridade: 1,
      ));
    }
    // Força ajuda a evitar quedas; avisa se faltou na semana.
    if (forcas < metaForcaSemana) {
      sugestoes.add(Sugestao(
        texto:
            'Exercícios de força ajudam a evitar quedas. Planeje $metaForcaSemana por semana (ex: levantar de uma cadeira).',
        prioridade: 1,
      ));
    }
    // Equilíbrio reduz risco de quedas; avisa se faltou na semana.
    if (equilibrios < metaEquilibrioSemana) {
      sugestoes.add(Sugestao(
        texto:
            'Treino de equilíbrio (${metaEquilibrioSemana}x/sem) reduz risco de quedas. Tente ficar em 1 pé por 10 seg.',
        prioridade: 2,
      ));
    }
    // Hidratação: avisa se poucos dias atingiram a meta de água.
    if (diasComAgua.length < 5) {
      sugestoes.add(Sugestao(
        texto:
            'Beba água durante o dia. Você atingiu a meta em ${diasComAgua.length} dias esta semana.',
        prioridade: 2,
      ));
    }
    // Alimentação: avisa se faltaram vegetais/frutas na semana.
    if (diasVegetais.length < 5) {
      sugestoes.add(Sugestao(
        texto:
            'Inclua vegetais ou frutas todo dia. Registrados em ${diasVegetais.length} dias esta semana.',
        prioridade: 3,
      ));
    }
    // Se tudo certo, reforça o bom trabalho.
    if (sugestoes.isEmpty) {
      sugestoes.add(Sugestao(
        texto: 'Parabéns! Você está dentro das metas. Continue assim para manter sua saúde.',
        prioridade: 3,
      ));
    }
    // Ordena para mostrar primeiro as sugestões mais importantes.
    sugestoes.sort((a, b) => a.prioridade.compareTo(b.prioridade));
    return sugestoes;
  }
}
