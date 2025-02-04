import 'package:flutter/material.dart';
import 'package:pokedex/dashboard/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedex',
      theme: ThemeData(

        primaryColor: Color(0xFF3D7DCA),
        hintColor: Color(0xFFFFCC00),
        scaffoldBackgroundColor: Color(0xFFF2F2F2),

        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),

        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF3D7DCA), // Azul de Pokémon
          textTheme: ButtonTextTheme.primary,
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF3D7DCA),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Estilos de iconos
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      home: const Dashboard(),
    );
  }
}
