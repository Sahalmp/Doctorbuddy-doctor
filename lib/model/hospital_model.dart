class HospitalModel {
  String? name, place;

  HospitalModel({this.name, this.place});

  factory HospitalModel.fromMap(map) {
    return HospitalModel(name: map['name'], place: map['place']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'place': place,
    };
  }
}
