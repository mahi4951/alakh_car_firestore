class BrandModel {
  final String id;
  final String name;
  final int order;
  final String? imageUrl; // Add a new property for the image URL

  BrandModel(
      {required this.id,
      required this.name,
      this.imageUrl,
      required this.order});

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'BrandName': name,
      'BrandOrder': order,
      'ImageUrl': imageUrl, // Include image URL in the map
    };
  }

  factory BrandModel.fromSnapshot(Map<String, dynamic> data) {
    return BrandModel(
      id: data['Id'],
      name: data['BrandName'],
      order: data['BrandOrder'],
      imageUrl: data['ImageUrl'], // Retrieve image URL from snapshot
    );
  }
}
