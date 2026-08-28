enum TipoAtividade { aerobico, forca, equilibrio, flexibilidade }
enum Intensidade { leve, moderada, intensa }

extension TipoAtividadeExt on TipoAtividade {
  String get label {
    switch (this) {
      case TipoAtividade.aerobico:
        return 'Aeróbico';
      case TipoAtividade.forca:
        return 'Força';
      case TipoAtividade.equilibrio:
        return 'Equilíbrio';
      case TipoAtividade.flexibilidade:
        return 'Flexibilidade';
    }
  }
}

extension IntensidadeExt on Intensidade {
  String get label {
    switch (this) {
      case Intensidade.leve:
        return 'Leve';
      case Intensidade.moderada:
        return 'Moderada';
      case Intensidade.intensa:
        return 'Intensa';
    }
  }
}

class Atividade {
  final int? id;
  final DateTime data;
  final TipoAtividade tipo;
  final int duracaoMinutos;
  final Intensidade intensidade;
  final int sentimento; // 1 a 5

  Atividade({
    this.id,
    required this.data,
    required this.tipo,
    required this.duracaoMinutos,
    required this.intensidade,
    required this.sentimento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'tipo': tipo.name,
      'duracaoMinutos': duracaoMinutos,
      'intensidade': intensidade.name,
      'sentimento': sentimento,
    };
  }

  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      id: map['id'],
      data: DateTime.parse(map['data']),
      tipo: TipoAtividade.values.byName(map['tipo']),
      duracaoMinutos: map['duracaoMinutos'],
      intensidade: Intensidade.values.byName(map['intensidade']),
      sentimento: map['sentimento'],
    );
  }
}
