class ColorsModels {
  String colors;

  ColorsModels({this.colors});

  ColorsModels.fromMap(Map<String, dynamic> map) {
    colors = map["colors"];
  }
}
