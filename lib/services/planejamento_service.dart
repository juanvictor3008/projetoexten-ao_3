import '../models/atividade.dart';
import '../models/alimentacao.dart';

// Item do plano semanal exibido na tela "Plano".
class PlanoItem {
  final String dia;
  final String atividade;
  final String detalhe;
  PlanoItem({required this.dia, required this.atividade, required this.detalhe});
}

// Gera o cronograma semanal de forma personalizada: observa o que faltou nos
// últimos 7 dias (força, equilíbrio, minutos, água, vegetais) e distribui as
// atividades sugeridas ao longo da semana.
class PlanejamentoService {
  static const int _metaMinutosSemana = 150;

  static List<PlanoItem> gerarPlanoSemanal(
      List<Atividade> atividades, List<Refeicao> refeicoes) {
    final agora = DateTime.now();
    final inicioSemana = agora.subtract(const Duration(days: 7));
    final ativSemana = atividades.where((a) => a.data.isAfter(inicioSemana)).toList();
    final refSemana = refeicoes.where((r) => r.data.isAfter(inicioSemana)).toList();

    // Calcula os déficits da última semana.
    final minutos = ativSemana.fold<int>(0, (s, a) => s + a.duracaoMinutos);
    final forcas = ativSemana.where((a) => a.tipo == TipoAtividade.forca).length;
    final equilibrios = ativSemana.where((a) => a.tipo == TipoAtividade.equilibrio).length;
    final diasComAgua = refSemana
        .where((r) => r.categoria == CategoriaAlimento.agua && r.quantidadeMl >= 1500)
        .map((r) => DateTime(r.data.year, r.data.month, r.data.day))
        .toSet();
    final diasVegetais = refSemana
        .where((r) => r.categoria == CategoriaAlimento.vegetais)
        .map((r) => DateTime(r.data.year, r.data.month, r.data.day))
        .toSet();

    final precisaForca = forcas < 2;
    final precisaEquilibrio = equilibrios < 2;
    final faltaMinutos = (_metaMinutosSemana - minutos).clamp(0, _metaMinutosSemana);

    final dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    final plano = <PlanoItem>[];
    int forcaFeitos = 0;
    int equilibrioFeitos = 0;
    for (int i = 0; i < 7; i++) {
      String atividade;
      String detalhe;
      // Prioriza os tipos em débito (força e equilíbrio) em dias alternados.
      if (precisaForca && forcaFeitos < 2 && i % 2 == 0) {
        atividade = 'Força';
        detalhe = 'Sentar e levantar da cadeira 10x';
        forcaFeitos++;
      } else if (precisaEquilibrio && equilibrioFeitos < 2 && i % 2 == 1) {
        atividade = 'Equilíbrio';
        detalhe = 'Ficar em 1 pé por 10 seg, 3x cada lado';
        equilibrioFeitos++;
      } else if (faltaMinutos > 0) {
        // Caminhadas para chegar perto da meta de 150 min/semana.
        atividade = (i == 5) ? 'Caminhada moderada' : 'Caminhada leve';
        detalhe = (i == 5)
            ? '30 min com leve aumento de ritmo'
            : '20 min de caminhada em ritmo confortável';
      } else {
        atividade = 'Flexibilidade';
        detalhe = 'Alongamento suave sentado, 15 min';
      }
      // Lembretes de hidratação e alimentação quando abaixo da meta.
      if (diasComAgua.length < 5) detalhe += ' | Beba ~1,5 L de água';
      if (diasVegetais.length < 5) detalhe += ' | Inclua vegetais/frutas';
      plano.add(PlanoItem(dia: dias[i], atividade: atividade, detalhe: detalhe));
    }
    return plano;
  }
}
