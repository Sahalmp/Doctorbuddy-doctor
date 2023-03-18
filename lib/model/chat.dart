class ChatMessages {
  String doctor;
  String patient;
  int timestamp;
  String content;
  String type;
  bool read;

  ChatMessages({
    required this.type,
    required this.doctor,
    required this.patient,
    required this.timestamp,
    required this.content,
    required this.read,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'doctor': doctor,
      'patient': patient,
      'timestamp': timestamp,
      'content': content,
      'read': read
    };
  }

  factory ChatMessages.fromMap(map) {
    return ChatMessages(
        type: map['type'],
        doctor: map['doctor'],
        patient: map['patient'],
        timestamp: map['timestamp'],
        content: map['content'],
        read: map['read']);
  }
}
