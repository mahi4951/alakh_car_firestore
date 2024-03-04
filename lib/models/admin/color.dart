class ColorModel {
  final String id;
  final String name;

  ColorModel({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'ColorName': name,
    };
  }

  factory ColorModel.fromSnapshot(Map<String, dynamic> data) {
    return ColorModel(
      id: data['Id'],
      name: data['ColorName'],
    );
  }
}
