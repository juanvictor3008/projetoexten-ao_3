import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../database/database_helper.dart';
import '../models/atividade.dart';

// Tela "Evolução": gráfico semanal e sequência de dias ativos.
class EvolucaoScreen extends StatefulWidget {
  const EvolucaoScreen({super.key});
  @override
  State<EvolucaoScreen> createState() => _EvolucaoScreenState();
}

class _EvolucaoScreenState extends State<EvolucaoScreen> {
  List<BarChartGroupData> _barras = []; // dados do gráfico de barras
  int _sequencia = 0; // dias consecutivos com ao menos uma atividade
  bool _carregando = true;
  late final StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _carregar();
    // Recarrega sozinho quando algo é registrado ou excluído.
    _sub = DatabaseHelper.instance.onChange.listen((_) => _carregar());
  }

  // Lê os registros e prepara as métricas de evolução.
  Future<void> _carregar() async {
    final ativ = await DatabaseHelper.instance.listarAtividades();
    final semanas = <int>[]; // total de minutos por semana (últimas 4)
    final agora = DateTime.now();

    // Percorre as 4 semanas anteriores, da mais antiga para a atual.
    for (int i = 3; i >= 0; i--) {
      final fim = agora.subtract(Duration(days: i * 7));
      final inicio = fim.subtract(const Duration(days: 7));
      final min = ativ
          .where((a) => a.data.isAfter(inicio) && a.data.isBefore(fim))
          .fold<int>(0, (s, a) => s + a.duracaoMinutos);
      semanas.add(min);
    }

    // Monta as barras do gráfico a partir dos totais semanais.
    _barras = semanas.asMap().entries.map((e) => BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(toY: e.value.toDouble(), color: Colors.green, width: 28)
          ],
        )).toList();

    // Calcula a sequência de dias ativos (contando a partir de hoje).
    final diasComAtiv =
        ativ.map((a) => DateTime(a.data.year, a.data.month, a.data.day)).toSet();
    int seq = 0;
    var d = DateTime.now();
    while (diasComAtiv.contains(DateTime(d.year, d.month, d.day))) {
      seq++;
      d = d.subtract(const Duration(days: 1));
    }

    if (!mounted) return;
    setState(() {
      _sequencia = seq;
      _carregando = false;
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Card com a sequência de dias ativos.
        Card(
          color: Colors.green.shade50,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('Sequência de dias ativos',
                    style: TextStyle(fontSize: 22)),
                Text('$_sequencia dias',
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Minutos de atividade por semana',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        // Gráfico de barras com os últimos 4 períodos semanais.
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              barGroups: _barras,
              titlesData: FlTitlesData(
                // Rótulos embaixo: identificam cada semana.
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) {
                      const labels = ['3 sem', '2 sem', '1 sem', 'Esta'];
                      final idx = v.toInt();
                      return Text(
                          idx >= 0 && idx < labels.length ? labels[idx] : '',
                          style: const TextStyle(fontSize: 14));
                    },
                  ),
                ),
                // Rótulos à esquerda: valores em minutos.
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true, reservedSize: 40)),
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}
