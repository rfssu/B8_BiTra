import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Register Berhasil', () {
    expect(validateRegister('Asra','asra29@gmail.com', '123456789'), isTrue);
  });

  test('Register Gagal', () {
    expect(validateRegister('Asr@','asra29@gmail.com', ''), isFalse);
  });
  
}
bool validateRegister(String username, String email, String password) {
  if (username.isEmpty || email.isEmpty){
    return false;
  }


   if (password.contains(' ')) {
    return false;
  }

   if (password.length < 8 || password.length > 16) {
    return false;
  }
  return true;
}