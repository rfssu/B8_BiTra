// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class userModel {
  String UserName;
  String email;
  String uId;
  String role;
  userModel({
    required this.UserName,
    required this.email,
    required this.uId,
    required this.role,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'UserName': UserName,
      'email': email,
      'uId': uId,
      'role': role,
    };
  }

  factory userModel.fromMap(Map<String, dynamic> map) {
    return userModel(
      UserName: map['UserName'] as String,
      email: map['email'] as String,
      uId: map['uId'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory userModel.fromJson(String source) => userModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
