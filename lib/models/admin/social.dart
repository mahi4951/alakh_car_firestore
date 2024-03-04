class SocialModel {
  final String id;
  final String contactEmail;
  final String facebookUrl;
  final String instagramUrl;
  final String youtubeUrl;

  SocialModel({
    required this.id,
    required this.contactEmail,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.youtubeUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'ContactEmail': contactEmail,
      'FacebookUrl': facebookUrl,
      'InstagramUrl': instagramUrl,
      'YoutubeUrl': youtubeUrl,
    };
  }

  factory SocialModel.fromSnapshot(Map<String, dynamic> data) {
    return SocialModel(
      id: data['Id'],
      contactEmail: data['ContactEmail'],
      facebookUrl: data['FacebookUrl'],
      instagramUrl: data['InstagramUrl'],
      youtubeUrl: data['YoutubeUrl'],
    );
  }
}
