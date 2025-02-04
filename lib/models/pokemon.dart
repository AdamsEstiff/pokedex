class Pokemon {
  int id;
  String name;
  int order;
  bool is_default;
  String location_area_encounters;

  Pokemon(
      {required this.id,
      required this.name,
      required this.order,
      required this.is_default,
      required this.location_area_encounters});

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
