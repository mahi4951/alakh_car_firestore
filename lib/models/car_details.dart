class CarsDetails {
  String? serviceTitle;
  String? regNo;
  String? formSubmitId;
  String? brands;
  String? servicePriceRange;
  String? servicePrice;
  String? fuel;
  String? year;
  String? color;
  String? version;
  String? insurance;
  String? km;
  String? colour;
  String? owners;
  String? model;
  String? gear;
  String? status;
  List<String> filePath = [];

  CarsDetails({
    this.serviceTitle,
    required this.filePath,
    this.regNo,
    this.formSubmitId,
    this.brands,
    this.servicePriceRange,
    this.servicePrice,
    this.fuel,
    this.owners,
    this.colour,
    this.insurance,
    this.km,
    this.version,
    this.year,
    this.model,
    this.gear,
    this.status,
  });

  CarsDetails.fromJson(Map<String, dynamic> json) {
    serviceTitle = json['service_title'];
    filePath = List<String>.from(json['file_path']);
    regNo = json['reg-no'];
    formSubmitId = json['form_submit_id'];
    servicePriceRange = json['service_price_range'];
    brands = json['brands'];
    servicePrice = json['service_price'];
    fuel = json['fuel'];
    owners = json['owners'];
    colour = json['colour'];
    year = json['year'];
    km = json['km'];
    version = json['version'];
    model = json['subbrand_drop'];
    insurance = json['insurance'];
    gear = json['gear'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[data]['service_title'] = serviceTitle;
    data[data]['file_path'] = filePath;
    data[data]['reg-no'] = regNo;
    data[data]['form_submit_id'] = formSubmitId;
    data[data]['service_price_range'] = servicePriceRange;
    data[data]['brands'] = brands;
    data[data]['service_price'] = servicePrice;
    data[data]['fuel'] = fuel;
    data[data]['owners'] = owners;
    data[data]['colour'] = colour;
    data[data]['year'] = year;
    data[data]['km'] = km;
    data[data]['version'] = version;
    data[data]['subbrand_drop'] = model;
    data[data]['insurance'] = insurance;
    data[data]['gear'] = gear;
    data[data]['status'] = status;

    return data;
  }
}
