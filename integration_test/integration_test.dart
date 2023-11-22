import 'package:flutter/material.dart';
import 'package:project_bitra/View/loginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project_bitra/View/registerpage.dart';
import 'package:project_bitra/main.dart' as app;

void main() {
  testWidgets('Register widget UI test', (WidgetTester tester) async{
    await Firebase.initializeApp();
    await tester.pumpWidget(const MaterialApp(
      home: RegisterPage(),));

      expect(find.text('Name'),findsOneWidget);
      expect(find.text('Email'),findsOneWidget);
      expect(find.text('Password'),findsOneWidget);
      expect(find.text('Register'),findsOneWidget);
      expect(find.text('textLogin'),findsOneWidget);

      await tester.enterText(find.byType(TextFormField).first,'icad');
      await Future.delayed(const Duration(seconds: 2));

      await tester.enterText(find.byType(TextFormField).at(1),'icad@gmail.com');
      await Future.delayed(const Duration(seconds: 2));

      await tester.enterText(find.byType(TextFormField).last,'12345678');
      await Future.delayed(const Duration(seconds: 2));

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      expect(find.text('Registration Successful'),findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      expect(find.byType(LoginPage), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}