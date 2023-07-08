import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_bitra/View/admin/dashboardAdmin.dart';
import 'package:project_bitra/View/loginScreen.dart';
import 'package:project_bitra/View/user/pemesanan.dart';
import 'package:project_bitra/View/user/userPage.dart';
import 'package:project_bitra/controller/pesanan_controller.dart';
import 'package:project_bitra/model/model_pesanan.dart';

Future main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:LoginPage(),
    );
      
  }
  }