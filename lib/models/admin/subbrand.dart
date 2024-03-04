class SubBrandModel {
  final String id;
  final String name;
  final String mainBrand;

  SubBrandModel(
      {required this.id, required this.name, required this.mainBrand});

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'SubBrandName': name,
      'MainBrand': mainBrand,
    };
  }

  factory SubBrandModel.fromSnapshot(Map<String, dynamic> data) {
    return SubBrandModel(
      id: data['Id'],
      name: data['SubBrandName'],
      mainBrand: data['MainBrand'],
    );
  }
}
