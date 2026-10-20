import 'package:flutter_test/flutter_test.dart';

import 'package:app_simulacao/main.dart';

void main() {
  testWidgets('exibe o formulário para comparar investimentos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AplicativoInvestimentos());

    expect(find.text('Compare antes de investir'), findsOneWidget);
    expect(find.text('Investimento 1'), findsOneWidget);
    expect(find.text('Investimento 2'), findsOneWidget);
    expect(find.text('Comparar investimentos'), findsOneWidget);
  });
}
