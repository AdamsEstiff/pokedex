class Sprite {
  String? backDefault;
  String? backFemale;
  String? backShiny;
  String? backShinyFemale;
  String? frontDefault;
  String? frontFemale;
  String? frontShiny;
  String? frontShinyFemale;

  Sprite({
    this.backDefault,
    this.backFemale,
    this.backShiny,
    this.backShinyFemale,
    this.frontDefault,
    this.frontFemale,
    this.frontShiny,
    this.frontShinyFemale,
  });

  Map<String, dynamic> toMap() {
    return {
      "backDefault": backDefault,
      "backFemale": backFemale,
      "backShiny": backShiny,
      "backShinyFemale": backShinyFemale,
      "frontDefault": frontDefault,
      "frontFemale": frontFemale,
      "frontShiny": frontShiny,
      "frontShinyFemale": frontShinyFemale,
    };
  }
}
