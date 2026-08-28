import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/atividade.dart';
import '../models/alimentacao.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const _ativKey = 'atividades';
  static const _refKey = 'alimentacao';
  SharedPreferences? _prefs;

  DatabaseHelper._init();

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

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
    return id;
  }

  Future<List<Atividade>> listarAtividades() async {
    final p = await prefs;
    final raw = p.getString(_ativKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    final ativs = list.map((m) => Atividade.fromMap(Map<String, dynamic>.from(m))).toList();
    ativs.sort((a, b) => b.data.compareTo(a.data));
    return ativs;
  }

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
    return id;
  }

  Future<List<Refeicao>> listarRefeicoes() async {
    final p = await prefs;
    final raw = p.getString(_refKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    final refs = list.map((m) => Refeicao.fromMap(Map<String, dynamic>.from(m))).toList();
    refs.sort((a, b) => b.data.compareTo(a.data));
    return refs;
  }

  Future<void> fechar() async {
    _prefs = null;
  }
}
