import 'package:dio/dio.dart';

class Pokemon {
  int? id;
  String? name;
  int? order;
  bool? is_default;
  String? location_area_encounters;

  Pokemon(
      {this.id,
      this.name,
      this.order,
      this.is_default,
      this.location_area_encounters});

  Future<Pokemon> getPokemon(String name) async {
    final response = await Dio().get('https://pokeapi.co/api/v2/pokemon/$name');
    Map body = response.data;

    return Pokemon(
        id: body["id"],
        name: body["name"],
        order: body["order"],
        is_default: body["is_default"],
        location_area_encounters: body["location_area_encounters"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "order": order,
      "is_default": is_default,
      "location_area_encounters": location_area_encounters
    };
  }
}
