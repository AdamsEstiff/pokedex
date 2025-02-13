import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController controller = TextEditingController();
  List<Pokemon> pokemons = [];
  String validateMessage = "";
  bool loading = false;
  bool isError = false;
  bool _validate = false;

  @override
  void initState() {
    // getPokemon();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> getPokemon(String name, StateSetter setState) async {
    try {
      if (controller.text.isEmpty) {
        setState(() {
          validateMessage = "El nombre del Pokemon no puede ser vacío";
          _validate = true;
        });
      } else {
        setState(() {
          loading = true;
        });
        Pokemon? pokemon = await Pokemon().getPokemon(name);
        if (pokemon != null) {
          setState(() {
            pokemons.add(pokemon);
            validateMessage = "";
            _validate = false;
          });
          controller.clear();
          Navigator.pop(context);
        } else {
          setState(() {
            validateMessage = "No se encuentra el nombre del Pokemón escrito";
            _validate = true;
          });
        }
      }
    } catch (e) {
      setState(() {
        isError = true;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future showAddPokemon(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text("Añadir Pokemons"),
              content: Wrap(
                children: [
                  TextField(
                    controller: controller,
                    onChanged: (data) {
                      setState(() {
                        _validate = data.isEmpty;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Pokemon',
                        errorText: _validate ? validateMessage : null,
                        errorStyle: TextStyle(color: Colors.red)),
                  )
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    "Cerrar",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    validateMessage = "";
                    _validate = false;
                    controller.clear();
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    "Aceptar",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () async {
                    await getPokemon(controller.text, setState);
                  },
                )
              ],
            );
          });
        });
  }

  Future<void> showModal(Pokemon pokemon) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon.name!,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Orden: ${pokemon.order}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Text(
                  'Habilidades:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ...pokemon.abilities!
                    .map((ability) => Text('• ${ability.name}'))
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokédex'),
        backgroundColor: Color(0xFFFFCC00),
        foregroundColor: Color(0xFF3D7DCA),
      ),
      body: AnimatedCrossFade(
        crossFadeState: pokemons.isNotEmpty
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: const Duration(seconds: 1),
        firstChild: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: pokemons.length,
              itemBuilder: (context, idx) {
                return Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFADD8E6),
                    border: Border.all(
                      color: Color(0xFFADD8E6),
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF3D7DCA),
                      child: Text(
                        pokemons[idx].name![0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      "${pokemons[idx]?.name}",
                    ),
                    onTap: () {
                      showModal(pokemons[idx]);
                    },
                  ),
                );
              }),
        ),
        secondChild: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Text(
              "No se han ingresado pokemons",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddPokemon(context);
        },
        backgroundColor: Colors.yellow, // Fondo amarillo
        child: const Icon(Icons.add, color: Colors.black), // Icono negro
      ),
    );
  }
}
