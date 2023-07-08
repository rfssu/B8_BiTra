import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project_bitra/View/user/progers_pesanan.dart';
import 'package:project_bitra/model/model_pesanan.dart';

import '../../controller/aut_controller.dart';
import '../../controller/pesanan_controller.dart';
import '../loginScreen.dart';


import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  var cc = PesananController();
  final authctrl = AuthController();
  final formkey = GlobalKey<FormState>();
  String? status;

  List<bool> _checkStatus = [];
  List<DocumentSnapshot>? data; // Status centang

  @override
  void initState() {
    super.initState();
    cc.getPesanan().then((data) {
      setState(() {
        _checkStatus = List<bool>.filled(data.length, false);
        this.data = data; // Inisialisasi variabel data
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
            },
            icon: Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          key: formkey,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Pesanan KU',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: cc.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<DocumentSnapshot> data = snapshot.data!;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      String status = data[index]['status'];

                      IconData iconData = Icons.clear; // Ikona default

                      if (status == 'diterima') {
                        iconData = Icons
                            .done; // Jika status diterima, ikon menjadi tanda centang
                      } else if (status == 'pending') {
                        iconData = Icons
                            .clear; // Jika status pending, ikon tetap menjadi tanda silang
                      } else if (status == 'selesai') {
                        iconData = Icons.done_all;
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  data[index]['nama']
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(data[index]['nama']),
                              subtitle: Text(data[index]['tanggal']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Konfirmasi'),
                                            content: Text(
                                                'Apakah Anda yakin ingin menghapus item ini?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Batal'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Hapus'),
                                                onPressed: () {
                                                  // Lakukan tindakan hapus disini
                                                  cc
                                                      .hapusPesanan(data[index]
                                                              ['id']
                                                          .toString())
                                                      .then((value) {
                                                    setState(() {
                                                      cc.getPesanan();
                                                    });
                                                  });
                                                  Navigator.of(context)
                                                      .pop(); // Tutup dialog setelah menghapus
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Pesanan dihapus'),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                        iconData), // Menggunakan ikon sesuai kondisi
                                    onPressed: () async {
                                      if (status == 'pending') {
                                        await cc.acceptPesanan(
                                            data[index]['id'].toString());
                                        setState(() {
                                          _checkStatus[index] = true;
                                        });

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminDashboard()), // Ganti HalamanTujuan dengan halaman yang ingin Anda reload
                                        );
                                      } else if (status == 'diterima') {
                                        await cc.pesananSelesai(
                                            data[index]['id'].toString());
                                        setState(() {
                                          _checkStatus[index] = false;
                                        });

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminDashboard()), // Ganti HalamanTujuan dengan halaman yang ingin Anda reload
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
