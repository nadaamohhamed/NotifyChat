class UserModel {
  final String id;
  final String? email;
  final String? phoneNumber;

  UserModel({
    required this.id,
    this.email,
    this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
