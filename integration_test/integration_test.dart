import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_bitra/View/registerpage.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project_bitra/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Register Test', () {
    testWidgets(
      'verify validasi input data register',
      (tester) async {
        app.main();
        
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(seconds: 2));
        await tester.tap(find.byType(TextButton));
        await Future.delayed(const Duration(seconds: 2));
        await tester.enterText(find.byType(TextFormField).at(0), 'Airel Javier Aldaffae');
        await Future.delayed(const Duration(seconds: 2));
        await tester.enterText(find.byType(TextFormField).at(1), 'sleman');
        await Future.delayed(const Duration(seconds: 2));
        await tester.enterText(find.byType(TextFormField).at(2), 'email@gmail.com');
        await Future.delayed(const Duration(seconds: 2));
        await tester.enterText(find.byType(TextFormField).at(3), '12345678');
        await Future.delayed(const Duration(seconds: 2));
        await tester.tap(find.byType(ElevatedButton));
        await Future.delayed(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        await Future.delayed(const Duration(seconds: 2));
        expect(find.byType(RegisterPage), findsOneWidget);
      },
    );
   });
}
