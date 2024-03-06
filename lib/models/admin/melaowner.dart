class MelaOwnerModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String location;

  MelaOwnerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'location': location,
    };
  }

  factory MelaOwnerModel.fromSnapshot(Map<String, dynamic> data) {
    return MelaOwnerModel(
      id: data['id'],
      name: data['name'],
      phone: data['phone'],
      address: data['address'],
      location: data['location'],
    );
  }
}
