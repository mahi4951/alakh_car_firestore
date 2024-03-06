class FuelModel {
  final String id;
  final String name;

  FuelModel({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'FuelName': name,
    };
  }

  factory FuelModel.fromSnapshot(Map<String, dynamic> data) {
    return FuelModel(
      id: data['Id'],
      name: data['FuelName'],
    );
  }
}
