class BannerModel {
  final String id;
  final String name;
  final String? imageUrl; // Add a new property for the image URL

  BannerModel({required this.id, required this.name, this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'BannerName': name,
      'ImageUrl': imageUrl, // Include image URL in the map
    };
  }

  factory BannerModel.fromSnapshot(Map<String, dynamic> data) {
    return BannerModel(
      id: data['Id'],
      name: data['BannerName'],
      imageUrl: data['ImageUrl'], // Retrieve image URL from snapshot
    );
  }
}
