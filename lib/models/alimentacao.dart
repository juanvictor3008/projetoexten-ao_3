// Categorias de alimentação usadas para orientar melhor a dieta do idoso.
enum CategoriaAlimento { proteina, vegetais, carboidrato, agua, doce }

// Devolve o nome legível (em português) de cada categoria de alimento.
extension CategoriaAlimentoExt on CategoriaAlimento {
  String get label {
    switch (this) {
      case CategoriaAlimento.proteina:
        return 'Proteína';
      case CategoriaAlimento.vegetais:
        return 'Vegetais/Frutas';
      case CategoriaAlimento.carboidrato:
        return 'Carboidrato';
      case CategoriaAlimento.agua:
        return 'Água';
      case CategoriaAlimento.doce:
        return 'Doce/Processado';
    }
  }
}

// Modelo que representa um registro de alimentação feito pelo usuário.
class Refeicao {
  final int? id;
  final DateTime data;
  final CategoriaAlimento categoria;
  final String descricao;
  final int quantidadeMl; // usado para água; 0 para as demais categorias

  Refeicao({
    this.id,
    required this.data,
    required this.categoria,
    required this.descricao,
    this.quantidadeMl = 0,
  });

  // Converte o objeto em Map para ser salvo (JSON) na persistência local.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'categoria': categoria.name,
      'descricao': descricao,
      'quantidadeMl': quantidadeMl,
    };
  }

  // Reconstrói o objeto a partir de um Map lido da persistência local.
  factory Refeicao.fromMap(Map<String, dynamic> map) {
    return Refeicao(
      id: map['id'],
      data: DateTime.parse(map['data']),
      categoria: CategoriaAlimento.values.byName(map['categoria']),
      descricao: map['descricao'],
      quantidadeMl: map['quantidadeMl'] ?? 0,
    );
  }
}
