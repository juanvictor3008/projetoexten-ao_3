class PlanoItem {
  final String dia;
  final String atividade;
  final String detalhe;
  PlanoItem({required this.dia, required this.atividade, required this.detalhe});
}

class PlanejamentoService {
  static List<PlanoItem> gerarPlanoSemanal() {
    const estrutura = [
      ('Seg', 'Caminhada leve', '20 min de caminhada em ritmo confortável'),
      ('Ter', 'Força', 'Sentar e levantar da cadeira 10x'),
      ('Qua', 'Caminhada leve', '20 min de caminhada'),
      ('Qui', 'Equilíbrio', 'Ficar em 1 pé por 10 seg, 3x cada lado'),
      ('Sex', 'Flexibilidade', 'Alongamento suave sentado, 15 min'),
      ('Sáb', 'Caminhada moderada', '30 min com leve aumento de ritmo'),
      ('Dom', 'Descanso ativo', 'Passeio tranquilo ou exercícios respiratórios'),
    ];
    return estrutura
        .map((e) => PlanoItem(dia: e.$1, atividade: e.$2, detalhe: e.$3))
        .toList();
  }
}
