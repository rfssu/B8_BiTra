import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('login Berhasil', () {
    expect(validateRegister('Rafi','rafi28@gmail.com', '123456789'), isTrue);
  });

  test('login Gagal', () {
    expect(validateRegister('R@fi','rafi28@gmail.com', '123456789'), isFalse);
  });
  

}
bool validateRegister(String username, String email,String password) {
  
  if (username.contains('@')) {
    return false;
  }

  return true;
}