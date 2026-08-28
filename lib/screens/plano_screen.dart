import 'package:flutter/material.dart';
import '../services/planejamento_service.dart';

// Tela "Plano": exibe o cronograma semanal de atividades.
class PlanoScreen extends StatelessWidget {
  const PlanoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gera (ou busca) o plano da semana.
    final plano = PlanejamentoService.gerarPlanoSemanal();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Seu plano da semana',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        // Um card por dia da semana, com o tipo de atividade e o detalhe.
        ...plano.map((p) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  child: Text(p.dia,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                title: Text(p.atividade,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                subtitle:
                    Text(p.detalhe, style: const TextStyle(fontSize: 18)),
              ),
            )),
      ],
    );
  }
}
