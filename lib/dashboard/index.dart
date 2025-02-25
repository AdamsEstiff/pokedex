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
  Pokemon? pokemon;
  String validateMessage = "";
  bool loading = false;
  bool isError = false;
  bool _validate = false;

  @override
  void initState() {
    getPokemon();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> getPokemon() async {
    final response =
        await Dio().get('https://pokeapi.co/api/v2/pokemon?limit=150');

    for (var result in response.data["results"]) {
      pokemons.add(Pokemon(name: result['name'], url: result["url"]));
    }

    setState(() {
      pokemons;
    });
  }

  Future<void> getPokemonInformation(String name, int index) async {
    try {
      if(pokemon !=null && pokemon?.name == name){
        pokemon = null;
      }else{
        setState(() {
          loading = true;
        });
        Pokemon? pokemonData = await Pokemon().getPokemon(name);
        if (pokemonData != null) {
          pokemons[index] = pokemonData;
          pokemon = pokemonData;
        }
      }

    } catch (e) {
      setState(() {
        validateMessage = "$e";
        _validate = true;
      });
    } finally {
      setState(() {
        loading = false;
        pokemons;
        pokemon;
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
                        validateMessage = "No puedes dejar el nombre vacío";
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
                    // await getPokemon(controller.text, setState);
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
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                        child: Image.network(
                      "${pokemon.sprite?.frontDefault}",
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                    )),
                    Text(
                      pokemon.name!,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
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
      body: Row(
        children: [
          if (pokemon != null)
            Expanded(
                child: Image.network(
              "${pokemon!.sprite?.frontDefault}",
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
            )),
          Expanded(
            child: AnimatedCrossFade(
              crossFadeState: pokemons.isNotEmpty
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 500),
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
                            color: pokemon == pokemons[idx]
                                ? Color(0xFF002E9D)
                                : Color(0xFFADD8E6),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ListTile(
                          // leading: CircleAvatar(
                          //     backgroundColor: Color(0xFF3D7DCA),
                          //     child: pokemons[idx].sprite?.frontDefault == null
                          //         ? Text(
                          //             "N/A",
                          //             style: TextStyle(color: Colors.white),
                          //           )
                          //         : Image.network(
                          //             "${pokemons[idx].sprite?.frontDefault}",
                          //             loadingBuilder: (BuildContext context,
                          //                 Widget child,
                          //                 ImageChunkEvent? loadingProgress) {
                          //               if (loadingProgress == null) {
                          //                 return child;
                          //               } else {
                          //                 return Center(
                          //                   child: CircularProgressIndicator(
                          //                     value: loadingProgress
                          //                                 .expectedTotalBytes !=
                          //                             null
                          //                         ? loadingProgress
                          //                                 .cumulativeBytesLoaded /
                          //                             (loadingProgress
                          //                                     .expectedTotalBytes ??
                          //                                 1)
                          //                         : null,
                          //                   ),
                          //                 );
                          //               }
                          //             },
                          //           )),
                          title: Text(
                            "${pokemons[idx]?.name}",
                            textAlign: TextAlign.center,
                          ),
                          onTap: () async {
                            // showModal(pokemons[idx]);
                            await getPokemonInformation(
                                pokemons[idx].name!, idx);
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
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showAddPokemon(context);
      //   },
      //   backgroundColor: Colors.yellow, // Fondo amarillo
      //   child: const Icon(Icons.add, color: Colors.black), // Icono negro
      // ),
    );
  }
}
