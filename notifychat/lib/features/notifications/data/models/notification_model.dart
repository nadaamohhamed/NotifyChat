import 'package:uuid/uuid.dart';

class NotificationModel {
  final String id;
  final String title;
  final String content;
  final DateTime receivedTime;

  NotificationModel({
    String? id,
    required this.title,
    required this.content,
    required this.receivedTime,
  }) : id = id ?? const Uuid().v4();

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['body'] as String,
      receivedTime: DateTime.parse(map['time']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': content,
      'time': receivedTime.toIso8601String(),
    };
  }
}
