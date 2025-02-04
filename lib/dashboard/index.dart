import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Pokemon? pokemon;
  bool isError = false;

  @override
  void initState() {
    getPokemon();
    super.initState();
  }

  Future<void> getPokemon() async {
    try {
      pokemon = await Pokemon().getPokemon("pikachu");
      setState(() {
        pokemon;
      });
    } catch (e) {
      setState(() {
        isError = true;
      });
    }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isError)
                Center(
                  child: Text("Ocurrio un error inesperado"),
                ),
              if (pokemon == null && !isError)
                Center(
                  child: Column(
                    children: [
                      Text(
                        "No se a cargado el Pokemón",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        color: Color(0xFFFFCC00),
                        // backgroundColor: Color(0xFFFFCC00),
                      ),
                    ],
                  ),
                ),
              if (pokemon != null && !isError)
                Center(
                  child: Text(
                    "${pokemon?.name}",
                    style: TextStyle(color: Colors.black),
                  ),
                )
            ],
          )),
    );
  }
}
