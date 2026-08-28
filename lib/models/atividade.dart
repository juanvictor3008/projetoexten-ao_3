// Tipos de atividade física que o app considera relevantes para idosos.
enum TipoAtividade { aerobico, forca, equilibrio, flexibilidade }

// Nível de esforço percebido durante a atividade.
enum Intensidade { leve, moderada, intensa }

// Devolve o nome legível (em português) de cada tipo de atividade.
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

// Devolve o nome legível (em português) de cada intensidade.
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

// Modelo que representa um registro de atividade física feito pelo usuário.
class Atividade {
  final int? id;
  final DateTime data;
  final TipoAtividade tipo;
  final int duracaoMinutos;
  final Intensidade intensidade;
  final int sentimento; // 1 a 5 (como a pessoa se sentiu depois)

  Atividade({
    this.id,
    required this.data,
    required this.tipo,
    required this.duracaoMinutos,
    required this.intensidade,
    required this.sentimento,
  });

  // Converte o objeto em Map para ser salvo (JSON) na persistência local.
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

  // Reconstrói o objeto a partir de um Map lido da persistência local.
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
