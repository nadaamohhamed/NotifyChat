import 'package:uuid/uuid.dart';

class ChannelModel {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;

  ChannelModel({
    String? id,
    required this.name,
    required this.description,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();

  factory ChannelModel.fromMap(Map<String, dynamic> map) {
    return ChannelModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(
        map['createdAt'] as String,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
