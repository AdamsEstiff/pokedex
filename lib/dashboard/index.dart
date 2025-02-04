import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    getPokemon();
    super.initState();
  }

  Future<void> getPokemon() async {
    final response = await Dio().get('https://pokeapi.co/api/v2/pokemon/ditto');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokédex'),
        backgroundColor: Color(0xFFFFCC00),
        foregroundColor: Color(0xFF3D7DCA),
      ),
      body: Container(
        color: Color(0xFFF2F2F2),
        child: Center(
          child: Text(
            '¡Bienvenido al mundo Pokémon!',
            style: TextStyle(color: Color(0xFF333333)),
          ),
        ),
      ),
    );
  }
}
