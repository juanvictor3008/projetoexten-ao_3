enum CategoriaAlimento { proteina, vegetais, carboidrato, agua, doce }

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

class Refeicao {
  final int? id;
  final DateTime data;
  final CategoriaAlimento categoria;
  final String descricao;
  final int quantidadeMl; // para água; 0 para outros

  Refeicao({
    this.id,
    required this.data,
    required this.categoria,
    required this.descricao,
    this.quantidadeMl = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'categoria': categoria.name,
      'descricao': descricao,
      'quantidadeMl': quantidadeMl,
    };
  }

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
