class BrandDetails {
  String? url;
  String? brandName;
  String? filePath;
  String? totalCars;

  BrandDetails({
    this.url,
    this.brandName,
    this.filePath,
    this.totalCars,
  });

  BrandDetails.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    brandName = json['brand_name'];
    filePath = json['file_path'];
    totalCars = json['total_cars'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['brand_name'] = brandName;
    data['file_path'] = filePath;
    data['total_cars'] = totalCars;

    return data;
  }
}
