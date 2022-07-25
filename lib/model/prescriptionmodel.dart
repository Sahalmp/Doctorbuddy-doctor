class Prescription {
  String drug;
  String usage;
  String duration;
  String remark;

  Prescription({
    required this.drug,
    required this.usage,
    required this.duration,
    required this.remark,
  });

  Map<String, dynamic> toMap() {
    return {
      'drug': drug,
      'usage': usage,
      'duration': duration,
      'remark': remark,
    };
  }

  factory Prescription.fromMap(map) {
    return Prescription(
      drug: map['drug'],
      usage: map['usage'],
      duration: map['duration'],
      remark: map['remark'],
    );
  }
}
