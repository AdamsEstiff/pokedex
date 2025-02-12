class Ability {
  String? name;
  String? url;
  bool? is_hidden;

  Ability({this.name, this.url, this.is_hidden});



  Map<String, dynamic> toMap() {
    return {"name": name, "url": url, "is_hidden": is_hidden};
  }
}
