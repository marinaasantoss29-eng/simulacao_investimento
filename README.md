# Simulador de Investimentos

Aplicativo Flutter educativo para comparar a evolução projetada de dois investimentos com capital inicial, aportes mensais, taxas de juros mensais e um período compartilhado.

## Funcionalidades

- Formulário com validação de valores e período.
- Prévia dos montantes finais enquanto os dados são preenchidos.
- Cálculo mês a mês de juros compostos para os dois investimentos.
- Comparação dos montantes finais, rendimentos acumulados e totais aplicados.
- Lista comparativa da evolução mensal e indicação do maior montante projetado.
- Ação para voltar ao formulário e iniciar outra comparação.

O modelo considera que os juros incidem sobre o saldo no início de cada mês e que o aporte mensal é aplicado ao final do mês. O rendimento total é o montante final menos o capital inicial e a soma dos aportes.

## Como executar

Com o Flutter instalado, execute dentro desta pasta:

```sh
flutter pub get
flutter run
```

Preencha os dados de cada investimento, informe o período em meses e toque em **Comparar investimentos**.

## Demonstração

Grave um vídeo curto mostrando o preenchimento dos dados, a prévia no formulário e a tela de comparação com a evolução mensal.
