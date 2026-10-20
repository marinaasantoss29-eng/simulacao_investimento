import 'package:flutter/material.dart';

import 'paginas/pagina_inicial.dart';

void main() {
  runApp(const AplicativoInvestimentos());
}

class AplicativoInvestimentos extends StatelessWidget {
  const AplicativoInvestimentos({super.key});

  @override
  Widget build(BuildContext context) {
    const corPrincipal = Color(0xFFF2B705);
    const fundo = Color(0xFFFFFBF1);
    const textoPrincipal = Color(0xFF302A1D);

    return MaterialApp(
      title: 'Comparador de investimentos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: corPrincipal,
          primary: corPrincipal,
          onPrimary: textoPrincipal,
          surface: fundo,
          onSurface: textoPrincipal,
        ),
        scaffoldBackgroundColor: fundo,
        appBarTheme: const AppBarTheme(
          backgroundColor: fundo,
          foregroundColor: textoPrincipal,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFEFA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8DFC6)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8DFC6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: corPrincipal, width: 1.5),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFEFA),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFECE4D2)),
          ),
        ),
        useMaterial3: true,
      ),
      home: const PaginaInicial(),
    );
  }
}
