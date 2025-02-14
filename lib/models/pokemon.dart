import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/ability.dart';
import 'package:pokedex/models/sprite.dart';

class Pokemon {
  int? id;
  String? name;
  int? order;
  bool? is_default;
  String? location_area_encounters;

  List<Ability>? abilities = [];
  Sprite? sprite;

  Pokemon(
      {this.id,
      this.name,
      this.order,
      this.is_default,
      this.location_area_encounters,
      this.abilities,
      this.sprite});

  Future<Pokemon?> getPokemon(String name) async {
    try {
      final response =
          await Dio().get('https://pokeapi.co/api/v2/pokemon/$name');
      Map body = response.data;
      List<Ability>? abilityList = [];

      for (var ability in body["abilities"]) {
        abilityList.add(Ability(
            name: ability["ability"]["name"],
            url: ability["ability"]["url"],
            is_hidden: ability["is_hidden"]));
      }


      return Pokemon(
          id: body["id"],
          name: body["name"],
          order: body["order"],
          is_default: body["is_default"],
          location_area_encounters: body["location_area_encounters"],
          abilities: abilityList,
          sprite: Sprite(
            backDefault: body["sprites"]["back_default"],
            backFemale: body["sprites"]["back_female"],
            backShiny: body["sprites"]["back_shiny"],
            backShinyFemale: body["sprites"]["back_shiny_female"],
            frontDefault: body["sprites"]["front_default"],
            frontFemale: body["sprites"]["front_female"],
            frontShiny: body["sprites"]["front_shiny"],
            frontShinyFemale: body["sprites"]["front_shiny_female"],
          )
      );
    } catch (e) {
      return null;
    }
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
