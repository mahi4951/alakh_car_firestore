class BannerDetails {
  String? bannerHeading;
  String? filePath;
  String? bannerSubHeading;

  BannerDetails({
    this.bannerHeading,
    this.filePath,
    this.bannerSubHeading,
  });

  BannerDetails.fromJson(Map<String, dynamic> json) {
    bannerHeading = json['banner_heading'];
    filePath = json['file_path'];
    bannerSubHeading = json['banner_sub_heading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner_heading'] = bannerHeading;
    data['file_path'] = filePath;
    data['banner_sub_heading'] = bannerSubHeading;
    return data;
  }
}
