class DoctorModel {
  String? uid,
      email,
      name,
      place,
      gender,
      qualification,
      regno,
      phno,
      image,
      category,
      hospital;

  DoctorModel({
    this.uid,
    this.email,
    this.name,
    this.place,
    this.gender,
    this.phno,
    this.qualification,
    this.regno,
    this.image,
    this.category,
  });

  factory DoctorModel.fromMap(map) {
    return DoctorModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      place: map['place'],
      gender: map['gender'],
      phno: map['phno'],
      qualification: map['qualification'],
      regno: map['regno'],
      image: map['image'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'gender': gender,
      'place': place,
      'name': name,
      'regno': regno,
      'phno': phno,
      'qualification': qualification,
      'image': image,
      'category': category,
    };
  }
}
