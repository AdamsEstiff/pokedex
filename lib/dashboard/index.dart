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
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(pokemon.name!),
                Text(pokemon.order!.toString()),
                for (var ability in pokemon.abilities!) Text("${ability.name}")
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
              AnimatedCrossFade(
                crossFadeState: pokemons.isNotEmpty
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(seconds: 1),
                firstChild: Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.width * 0.8,
                      maxWidth: MediaQuery.of(context).size.width),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: pokemons.length,
                      itemBuilder: (context, idx) {
                        return ListTile(
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
                        );
                      }),
                ),
                secondChild: Center(
                  child: Text(
                    "No se han ingresado pokemons",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          )),
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
