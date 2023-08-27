import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String id;
  String role;
  String email;
  String password;

  Users(
      {required this.id,
        required this.email,
        required this.role,
        required this.password});

  operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'email':
        return email;
      case 'password':
        return password;
      case 'role':
        return role;
      default:
        throw Exception('Invalid key: $key');
    }
  }

  // factory constructor to create a User object from a JSON object
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'email': email,
      'password': password,
    };
  }

  void initial() {
    id = '';
    email = '';
    role = '';
    password = '';
  }

  factory Users.fromSnapshot(QueryDocumentSnapshot<Object?> snapshot) {
    return Users(
      id: snapshot.id,
      password: snapshot['password'] ?? '',
      email: snapshot['email'] ?? '',
      role: snapshot['role'] ?? '',
    );
  }
}
