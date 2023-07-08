// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';


class UserModel {
  String userName;
  String email;
  String uId;
  String role;
  UserModel({
    required this.userName,
    required this.email,
    required this.uId,
    required this.role,
  });
 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'email': email,
      'uId': uId,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userName: map['userName'] as String,
      email: map['email'] as String,
      uId: map['uId'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
  static UserModel? fromFirebaseUser(User user) {}
}
