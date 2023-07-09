import 'dart:async';
import 'dart:io';

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

import '../user/updatePesanan.dart';

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

    return WillPopScope( onWillPop: () async {
          bool? exitConfirmed = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Konfirmasi'),
                content: Text('Apakah Anda yakin ingin keluar?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Batal'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text('Keluar'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      exit(0);
                    },
                  ),
                ],
              );
            },
          );
          return exitConfirmed ?? false;
        },
    child : Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard Admin BiTra',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
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
                          onTap: () async {
                            BuildContext sheetContext = context;
                            DocumentSnapshot pesananSnapshot = await cc
                                .getPesananById(data[index]['id'].toString());
                            showModalBottomSheet(
                              context: sheetContext,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Detail Pesanan',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Text(
                                        'Nama: ${pesananSnapshot['nama']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Alamat: ${pesananSnapshot['alamat']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'No HP: ${pesananSnapshot['noHp']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Nama Barang: ${pesananSnapshot['namaBarang']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Jumlah Barang: ${pesananSnapshot['jumlahBarang']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Tanggal Pengambilan: ${pesananSnapshot['tanggal']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Status: ${pesananSnapshot['status']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(sheetContext).pop();
                                          },
                                          child: const Text('Tutup'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  _getIconByNamaBarang(
                                      data[index]['namaBarang']),
                                  color: Colors.white,
                                  size: 24,
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
    )
    );
  }

  IconData _getIconByNamaBarang(String namaBarang) {
    switch (namaBarang.toLowerCase()) {
      case 'meja':
        return Icons.table_chart;
      case 'kursi':
        return Icons.chair;
      case 'sofa':
        return Icons.weekend;
      case 'almari':
        return Icons.storefront_sharp;
      case 'kasur':
        return Icons.bed;
      default:
        return Icons.device_unknown;
    }
  }
}
