class Investimento {
  const Investimento({
    required this.nome,
    required this.capitalInicial,
    required this.aplicacaoMensal,
    required this.taxaMensalPercentual,
  });

  final String nome;
  final double capitalInicial;
  final double aplicacaoMensal;
  final double taxaMensalPercentual;
}

class ResultadoInvestimento {
  const ResultadoInvestimento({
    required this.investimento,
    required this.evolucaoMensal,
  });

  final Investimento investimento;
  final List<double> evolucaoMensal;

  double get montanteFinal => evolucaoMensal.last;

  double get totalInvestido =>
      investimento.capitalInicial +
      investimento.aplicacaoMensal * evolucaoMensal.length;

  double get rendimentoTotal => montanteFinal - totalInvestido;
}

class SimulacaoInvestimento {
  const SimulacaoInvestimento({
    required this.periodoMeses,
    required this.resultados,
  });

  final int periodoMeses;
  final List<ResultadoInvestimento> resultados;

  factory SimulacaoInvestimento.calcular({
    required Investimento primeiro,
    required Investimento segundo,
    required int periodoMeses,
  }) {
    if (periodoMeses < 1) {
      throw ArgumentError.value(periodoMeses, 'periodoMeses');
    }

    return SimulacaoInvestimento(
      periodoMeses: periodoMeses,
      resultados: [
        _calcularResultado(primeiro, periodoMeses),
        _calcularResultado(segundo, periodoMeses),
      ],
    );
  }

  static ResultadoInvestimento _calcularResultado(
    Investimento investimento,
    int periodoMeses,
  ) {
    final taxa = investimento.taxaMensalPercentual / 100;
    var saldo = investimento.capitalInicial;
    final evolucao = <double>[];

    // Os juros são calculados sobre o saldo; o aporte entra no fim do mês.
    for (var mes = 0; mes < periodoMeses; mes++) {
      saldo = saldo * (1 + taxa) + investimento.aplicacaoMensal;
      evolucao.add(saldo);
    }

    return ResultadoInvestimento(
      investimento: investimento,
      evolucaoMensal: List.unmodifiable(evolucao),
    );
  }
}
