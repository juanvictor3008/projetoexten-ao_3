import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/atividade.dart';
import '../models/alimentacao.dart';

// Camada de persistência local. Usa shared_preferences, que funciona tanto
// na web (localStorage) quanto no Android (preferências do app), sem servidor.
// Os registros são salvos como JSON numa única chave cada (lista de objetos).
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const _ativKey = 'atividades'; // chave da lista de atividades
  static const _refKey = 'alimentacao'; // chave da lista de refeições
  static const _perfilKey = 'perfil_nome'; // nome do idoso (modo cuidador)
  SharedPreferences? _prefs;

  // Avisa as telas quando algo muda (usado para auto-atualizar a UI).
  final StreamController<void> _onChange = StreamController<void>.broadcast();
  Stream<void> get onChange => _onChange.stream;

  DatabaseHelper._init();

  // Retorna a instância de SharedPreferences, criando-a uma vez só.
  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Salva uma atividade: lê a lista, adiciona o item e reescreve o JSON.
  Future<int> inserirAtividade(Atividade a) async {
    final p = await prefs;
    final lista = await listarAtividades();
    final id = DateTime.now().millisecondsSinceEpoch;
    final nova = Atividade(
      id: id,
      data: a.data,
      tipo: a.tipo,
      duracaoMinutos: a.duracaoMinutos,
      intensidade: a.intensidade,
      sentimento: a.sentimento,
    );
    lista.add(nova);
    await p.setString(_ativKey, jsonEncode(lista.map((e) => e.toMap()).toList()));
    _onChange.add(null); // notifica as telas
    return id;
  }

  // Lê e reconstrói a lista de atividades (mais recentes primeiro).
  Future<List<Atividade>> listarAtividades() async {
    final p = await prefs;
    final raw = p.getString(_ativKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    final ativs = list.map((m) => Atividade.fromMap(Map<String, dynamic>.from(m))).toList();
    ativs.sort((a, b) => b.data.compareTo(a.data));
    return ativs;
  }

  // Salva uma refeição: lê a lista, adiciona o item e reescreve o JSON.
  Future<int> inserirRefeicao(Refeicao r) async {
    final p = await prefs;
    final lista = await listarRefeicoes();
    final id = DateTime.now().millisecondsSinceEpoch;
    final nova = Refeicao(
      id: id,
      data: r.data,
      categoria: r.categoria,
      descricao: r.descricao,
      quantidadeMl: r.quantidadeMl,
    );
    lista.add(nova);
    await p.setString(_refKey, jsonEncode(lista.map((e) => e.toMap()).toList()));
    _onChange.add(null);
    return id;
  }

  // Lê e reconstrói a lista de refeições (mais recentes primeiro).
  Future<List<Refeicao>> listarRefeicoes() async {
    final p = await prefs;
    final raw = p.getString(_refKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    final refs = list.map((m) => Refeicao.fromMap(Map<String, dynamic>.from(m))).toList();
    refs.sort((a, b) => b.data.compareTo(a.data));
    return refs;
  }

  // Remove uma atividade pelo id e avisa as telas.
  Future<void> excluirAtividade(int id) async {
    final p = await prefs;
    final lista = await listarAtividades();
    lista.removeWhere((a) => a.id == id);
    await p.setString(_ativKey, jsonEncode(lista.map((e) => e.toMap()).toList()));
    _onChange.add(null);
  }

  // Remove uma refeição pelo id e avisa as telas.
  Future<void> excluirRefeicao(int id) async {
    final p = await prefs;
    final lista = await listarRefeicoes();
    lista.removeWhere((r) => r.id == id);
    await p.setString(_refKey, jsonEncode(lista.map((e) => e.toMap()).toList()));
    _onChange.add(null);
  }

  // Perfil: nome do idoso, usado no relatório do cuidador.
  Future<void> salvarNome(String nome) async {
    final p = await prefs;
    await p.setString(_perfilKey, nome);
  }

  Future<String> lerNome() async {
    final p = await prefs;
    return p.getString(_perfilKey) ?? '';
  }

  // Libera a instância em memória (não apaga os dados salvos).
  Future<void> fechar() async {
    _prefs = null;
  }
}
