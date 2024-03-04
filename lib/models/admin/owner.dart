class OwnerModel {
  final String id;
  final String name;

  OwnerModel({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Owners': name,
    };
  }

  factory OwnerModel.fromSnapshot(Map<String, dynamic> data) {
    return OwnerModel(
      id: data['Id'],
      name: data['Owners'],
    );
  }
}
