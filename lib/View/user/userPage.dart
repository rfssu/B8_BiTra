import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bitra/View/loginScreen.dart';
import 'package:project_bitra/View/user/pemesanan.dart';
import 'package:project_bitra/View/user/progers_pesanan.dart';
import 'package:project_bitra/View/user/updatePesanan.dart';
import 'package:project_bitra/controller/aut_controller.dart';
import 'package:project_bitra/controller/pesanan_controller.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const ProgresPesanan(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.blue.shade700,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.pending, title: 'Progress'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var cc = PesananController();
  final authctrl = AuthController();
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    cc.getPesanan();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool? exitConfirmed = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Konfirmasi'),
                content: const Text('Apakah Anda yakin ingin keluar?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Batal'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: const Text('Keluar'),
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
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'BiTra',
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
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Pesanan KU',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
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

                          if (status != 'pending') {
                            return Container(); // Return an empty container if status is not 'pending'
                          }

                          if (data[index]['uId'] == user.uid) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  BuildContext sheetContext = context;
                                  DocumentSnapshot pesananSnapshot =
                                      await cc.getPesananById(
                                          data[index]['id'].toString());

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
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              'Alamat: ${pesananSnapshot['alamat']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              'No HP: ${pesananSnapshot['noHp']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              'Nama Barang: ${pesananSnapshot['namaBarang']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              'Jumlah Barang: ${pesananSnapshot['jumlahBarang']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              'Tanggal Pengambilan: ${pesananSnapshot['tanggal']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              'Status: ${pesananSnapshot['status']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 16.0),
                                            if (pesananSnapshot['status'] ==
                                                'pending')
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                UpdatePesanan(
                                                                  beforenama: data[
                                                                              index]
                                                                          [
                                                                          'nama']
                                                                      .toString(),
                                                                  beforealamat:
                                                                      data[index]
                                                                              [
                                                                              'alamat']
                                                                          .toString(),
                                                                  beforenoHp: data[
                                                                              index]
                                                                          [
                                                                          'noHp']
                                                                      .toString(),
                                                                  beforeanamaBarang:
                                                                      data[index]
                                                                              [
                                                                              'namaBarang']
                                                                          .toString(),
                                                                  beforejumlahBarang:
                                                                      int.parse(data[index]
                                                                              [
                                                                              'jumlahBarang']
                                                                          .toString()), // Convert to int

                                                                  beforetanggal:
                                                                      data[index]
                                                                              [
                                                                              'tanggal']
                                                                          .toString(),
                                                                  status: data[
                                                                              index]
                                                                          [
                                                                          'status']
                                                                      .toString(),
                                                                  id: data[index]
                                                                          ['id']
                                                                      .toString(),
                                                                  uId: data[index]
                                                                          [
                                                                          'uId']
                                                                      .toString(),
                                                                )));
                                                  },
                                                  child: const Text('Edit'),
                                                ),
                                              ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(sheetContext)
                                                      .pop();
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
                                  shadowColor: Colors.green,
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
                                    title: Text(data[index]['namaBarang']),
                                    subtitle: Text(data[index]['tanggal']),
                                    hoverColor: Colors.green,
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Konfirmasi'),
                                              content: const Text(
                                                  'Apakah Anda yakin ingin menghapus item ini?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Batal'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Hapus'),
                                                  onPressed: () {
                                                    // Lakukan tindakan hapus disini
                                                    cc
                                                        .hapusPesanan(
                                                            data[index]['id']
                                                                .toString())
                                                        .then((value) {
                                                      setState(() {
                                                        cc.getPesanan();
                                                      });
                                                    });
                                                    Navigator.of(context)
                                                        .pop(); // Tutup dialog setelah menghapus
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
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
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          heroTag: "btn1",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FormPemesanan(),
                              ),
                            );
                          },
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(height: 16.0),
                        FloatingActionButton(
                          heroTag: "btn2",
                          onPressed: () {
                            // Aksi ketika tombol Kontak WhatsApp diklik
                            print('Kontak WhatsApp');
                          },
                          child: const Icon(Icons.chat),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
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
