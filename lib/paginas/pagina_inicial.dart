import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/simulacao.dart';
import 'pagina_resultado.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final _formKey = GlobalKey<FormState>();
  final _capital1Controller = TextEditingController();
  final _aporte1Controller = TextEditingController();
  final _taxa1Controller = TextEditingController();
  final _capital2Controller = TextEditingController();
  final _aporte2Controller = TextEditingController();
  final _taxa2Controller = TextEditingController();
  final _periodoController = TextEditingController();

  SimulacaoInvestimento? _previsualizacao;

  @override
  void dispose() {
    _capital1Controller.dispose();
    _aporte1Controller.dispose();
    _taxa1Controller.dispose();
    _capital2Controller.dispose();
    _aporte2Controller.dispose();
    _taxa2Controller.dispose();
    _periodoController.dispose();
    super.dispose();
  }

  double? _lerValor(TextEditingController controller) {
    final texto = controller.text.trim().replaceAll(',', '.');
    final valor = double.tryParse(texto);
    return valor != null && valor.isFinite ? valor : null;
  }

  void _atualizarPrevisualizacao() {
    final capital1 = _lerValor(_capital1Controller);
    final aporte1 = _lerValor(_aporte1Controller);
    final taxa1 = _lerValor(_taxa1Controller);
    final capital2 = _lerValor(_capital2Controller);
    final aporte2 = _lerValor(_aporte2Controller);
    final taxa2 = _lerValor(_taxa2Controller);
    final periodo = int.tryParse(_periodoController.text.trim());

    SimulacaoInvestimento? novaPrevisualizacao;
    if (capital1 != null &&
        aporte1 != null &&
        taxa1 != null &&
        capital2 != null &&
        aporte2 != null &&
        taxa2 != null &&
        periodo != null &&
        periodo > 0 &&
        capital1 >= 0 &&
        aporte1 >= 0 &&
        taxa1 >= 0 &&
        capital2 >= 0 &&
        aporte2 >= 0 &&
        taxa2 >= 0) {
      novaPrevisualizacao = SimulacaoInvestimento.calcular(
        primeiro: Investimento(
          nome: 'Investimento 1',
          capitalInicial: capital1,
          aplicacaoMensal: aporte1,
          taxaMensalPercentual: taxa1,
        ),
        segundo: Investimento(
          nome: 'Investimento 2',
          capitalInicial: capital2,
          aplicacaoMensal: aporte2,
          taxaMensalPercentual: taxa2,
        ),
        periodoMeses: periodo,
      );
    }

    // Atualiza a prévia em tempo real e a oculta enquanto os dados estão incompletos.
    setState(() => _previsualizacao = novaPrevisualizacao);
  }

  String? _validarValor(String? texto) {
    final valor = double.tryParse((texto ?? '').trim().replaceAll(',', '.'));
    if (valor == null || !valor.isFinite) {
      return 'Informe um número válido.';
    }
    if (valor < 0) {
      return 'O valor não pode ser negativo.';
    }
    return null;
  }

  String? _validarPeriodo(String? texto) {
    final periodo = int.tryParse((texto ?? '').trim());
    if (periodo == null || periodo < 1) {
      return 'Informe um período inteiro maior que zero.';
    }
    return null;
  }

  Widget _campo({
    required String rotulo,
    required TextEditingController controller,
    required String sufixo,
    bool inteiro = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: !inteiro),
      inputFormatters: inteiro
          ? [FilteringTextInputFormatter.digitsOnly]
          : [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
      decoration: InputDecoration(labelText: rotulo, suffixText: sufixo),
      validator: inteiro ? _validarPeriodo : _validarValor,
      onChanged: (_) => _atualizarPrevisualizacao(),
    );
  }

  Widget _secaoInvestimento({
    required String titulo,
    required Color cor,
    required TextEditingController capitalController,
    required TextEditingController aporteController,
    required TextEditingController taxaController,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: cor.withValues(alpha: 0.12),
                  child: Icon(Icons.show_chart, color: cor, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _campo(
              rotulo: 'Capital inicial',
              controller: capitalController,
              sufixo: 'R\$',
            ),
            const SizedBox(height: 14),
            _campo(
              rotulo: 'Aplicação mensal',
              controller: aporteController,
              sufixo: 'R\$',
            ),
            const SizedBox(height: 14),
            _campo(
              rotulo: 'Taxa de juros mensal',
              controller: taxaController,
              sufixo: '%',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _comparar() async {
    if (!_formKey.currentState!.validate()) return;

    final simulacao = SimulacaoInvestimento.calcular(
      primeiro: Investimento(
        nome: 'Investimento 1',
        capitalInicial: _lerValor(_capital1Controller)!,
        aplicacaoMensal: _lerValor(_aporte1Controller)!,
        taxaMensalPercentual: _lerValor(_taxa1Controller)!,
      ),
      segundo: Investimento(
        nome: 'Investimento 2',
        capitalInicial: _lerValor(_capital2Controller)!,
        aplicacaoMensal: _lerValor(_aporte2Controller)!,
        taxaMensalPercentual: _lerValor(_taxa2Controller)!,
      ),
      periodoMeses: int.parse(_periodoController.text.trim()),
    );

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaginaResultado(simulacao: simulacao),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Investimentos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  const Text(
                    'Compare antes de investir',
                    style: TextStyle(
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF302A1D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preencha os dados e veja como cada opção pode evoluir.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _campo(
                        rotulo: 'Período da simulação',
                        controller: _periodoController,
                        sufixo: 'meses',
                        inteiro: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final primeiro = _secaoInvestimento(
                        titulo: 'Investimento 1',
                        cor: const Color(0xFFD39A00),
                        capitalController: _capital1Controller,
                        aporteController: _aporte1Controller,
                        taxaController: _taxa1Controller,
                      );
                      final segundo = _secaoInvestimento(
                        titulo: 'Investimento 2',
                        cor: const Color(0xFF8A6D1D),
                        capitalController: _capital2Controller,
                        aporteController: _aporte2Controller,
                        taxaController: _taxa2Controller,
                      );

                      if (constraints.maxWidth >= 680) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: primeiro),
                            const SizedBox(width: 14),
                            Expanded(child: segundo),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          primeiro,
                          const SizedBox(height: 12),
                          segundo,
                        ],
                      );
                    },
                  ),
                  if (_previsualizacao case final simulacao?) ...[
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Prévia do montante final',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Investimento 1: ${formatarMoeda(simulacao.resultados[0].montanteFinal)}',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Investimento 2: ${formatarMoeda(simulacao.resultados[1].montanteFinal)}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _comparar,
                    icon: const Icon(Icons.compare_arrows),
                    label: const Text('Comparar investimentos'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Simulação educativa. Os valores não representam garantia de rentabilidade.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
