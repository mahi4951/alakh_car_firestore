class FuelDetails {
  String? fuelName;
  String? alias;
  String? totalCars;

  FuelDetails({
    this.fuelName,
    this.alias,
    this.totalCars,
  });

  FuelDetails.fromJson(Map<String, dynamic> json) {
    fuelName = json['fuel_name'];
    alias = json['alias'];
    totalCars = json['total_cars'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fuel_name'] = fuelName;
    data['alias'] = alias;
    data['total_cars'] = totalCars;

    return data;
  }
}
