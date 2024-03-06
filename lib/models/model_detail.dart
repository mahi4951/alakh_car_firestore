class ModelDetails {
  String? id;
  String? name;
  String? alias;
  String? classId;
  String? brand;

  ModelDetails({
    this.id,
    this.name,
    this.alias,
    this.classId,
    this.brand,
  });

  ModelDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    classId = json['class_id'];
    brand = json['brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['alias'] = alias;
    data['class_id'] = classId;
    data['brand'] = brand;

    return data;
  }
}
