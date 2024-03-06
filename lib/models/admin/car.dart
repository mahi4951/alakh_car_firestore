class CarModel {
  final String id;
  final String name;
  final String? brandName;
  final String? regNo;
  final String? carPrice;
  final String? fuelName;
  final String? year;
  final String? version;
  final String? insurance;
  final String? km;
  final String? colorName;
  final String? owners;
  final String? gear;
  final String? status;
  final String? subBrandName;
  final String? location;
  final List<String>? imagesUrls;

  CarModel({
    required this.id,
    required this.name,
    this.brandName,
    this.regNo,
    this.carPrice,
    this.fuelName,
    this.year,
    this.version,
    this.insurance,
    this.km,
    this.colorName,
    this.owners,
    this.gear,
    this.status,
    this.subBrandName,
    this.location,
    this.imagesUrls,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'CarName': name,
      'BrandName': brandName,
      'RegNo': regNo,
      'CarPrice': carPrice,
      'FuelName': fuelName,
      'Year': year,
      'Version': version,
      'Insurance': insurance,
      'Km': km,
      'ColorName': colorName,
      'Owners': owners,
      'Gear': gear,
      'Status': status,
      'SubBrandName': subBrandName,
      'Location': location,
      'ImagesUrls': imagesUrls,
    };
  }

  factory CarModel.fromSnapshot(Map<String, dynamic> data) {
    return CarModel(
      id: data['Id'],
      name: data['CarName'],
      brandName: data['BrandName'],
      regNo: data['RegNo'],
      carPrice: data['CarPrice'],
      fuelName: data['FuelName'],
      year: data['Year'],
      version: data['Version'],
      insurance: data['Insurance'],
      km: data['Km'],
      colorName: data['ColorName'],
      owners: data['Owners'],
      gear: data['Gear'],
      status: data['Status'],
      subBrandName: data['SubBrandName'],
      location: data['Location'],
      imagesUrls: List<String>.from(data['ImagesUrls'] ?? []),
    );
  }
}
