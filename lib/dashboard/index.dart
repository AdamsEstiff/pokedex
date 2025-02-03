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
    print(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de Pokemons",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Text("body"),
      ),
    );
  }
}
