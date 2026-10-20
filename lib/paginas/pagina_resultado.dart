import 'package:flutter/material.dart';

import '../models/simulacao.dart';

String formatarMoeda(double valor) {
  final partes = valor.toStringAsFixed(2).split('.');
  final inteiro = partes[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return 'R\$ $inteiro,${partes[1]}';
}

class PaginaResultado extends StatelessWidget {
  const PaginaResultado({super.key, required this.simulacao});

  final SimulacaoInvestimento simulacao;

  @override
  Widget build(BuildContext context) {
    final primeiro = simulacao.resultados[0];
    final segundo = simulacao.resultados[1];
    final melhor = primeiro.montanteFinal >= segundo.montanteFinal
        ? primeiro
        : segundo;
    final maiorMontante = primeiro.montanteFinal > segundo.montanteFinal
        ? primeiro.montanteFinal
        : segundo.montanteFinal;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado da comparação')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Text(
                  'Sua comparação',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF302A1D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Projeção para ${simulacao.periodoMeses} '
                  '${simulacao.periodoMeses == 1 ? 'mês' : 'meses'}',
                  style: TextStyle(color: Colors.blueGrey.shade700),
                ),
                const SizedBox(height: 18),
                Card(
                  color: const Color(0xFFFFF2CC),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.emoji_events_outlined,
                          color: Color(0xFFD39A00),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${melhor.investimento.nome} tem o maior montante '
                            'projetado: ${formatarMoeda(melhor.montanteFinal)}.',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _cartaoResumo(
                  primeiro,
                  cor: const Color(0xFFD39A00),
                  maiorMontante: maiorMontante,
                ),
                const SizedBox(height: 2),
                _cartaoResumo(
                  segundo,
                  cor: const Color(0xFF8A6D1D),
                  maiorMontante: maiorMontante,
                ),
                const SizedBox(height: 22),
                const Text(
                  'Evolução mês a mês',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'O saldo considera os juros do mês e o aporte ao final de cada período.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blueGrey.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                ...List<Widget>.generate(
                  simulacao.periodoMeses,
                  (indice) => _linhaComparativa(
                    mes: indice + 1,
                    primeiro: primeiro.evolucaoMensal[indice],
                    segundo: segundo.evolucaoMensal[indice],
                    cor1: const Color(0xFFD39A00),
                    cor2: const Color(0xFF8A6D1D),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Fazer nova comparação'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cartaoResumo(
    ResultadoInvestimento resultado, {
    required Color cor,
    required double maiorMontante,
  }) {
    final progresso = maiorMontante == 0
        ? 0.0
        : resultado.montanteFinal / maiorMontante;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    resultado.investimento.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Montante final'),
            const SizedBox(height: 3),
            Text(
              formatarMoeda(resultado.montanteFinal),
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            const SizedBox(height: 14),
            _linhaResumo(
              'Rendimento total',
              formatarMoeda(resultado.rendimentoTotal),
            ),
            const SizedBox(height: 7),
            _linhaResumo(
              'Total aplicado',
              formatarMoeda(resultado.totalInvestido),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progresso,
                minHeight: 8,
                color: cor,
                backgroundColor: cor.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _linhaResumo(String titulo, String valor) {
    return Row(
      children: [
        Expanded(child: Text(titulo, style: const TextStyle(fontSize: 13))),
        Text(
          valor,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _linhaComparativa({
    required int mes,
    required double primeiro,
    required double segundo,
    required Color cor1,
    required Color cor2,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            SizedBox(
              width: 48,
              child: Text(
                '$mesº mês',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: _valorEvolucao(
                primeiro,
                cor: cor1,
                alinhamento: CrossAxisAlignment.start,
              ),
            ),
            Expanded(
              child: _valorEvolucao(
                segundo,
                cor: cor2,
                alinhamento: CrossAxisAlignment.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _valorEvolucao(
    double valor, {
    required Color cor,
    required CrossAxisAlignment alinhamento,
  }) {
    return Column(
      crossAxisAlignment: alinhamento,
      children: [
        Text(
          formatarMoeda(valor),
          textAlign: alinhamento == CrossAxisAlignment.end
              ? TextAlign.right
              : TextAlign.left,
          style: TextStyle(
            color: cor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
