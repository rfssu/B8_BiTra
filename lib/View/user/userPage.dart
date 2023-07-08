import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
        items: [
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
            title: Text('My App'),
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
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
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
                          if (status != 'pending') {
                            return Container(); // Return an empty container if status is not 'pending'
                          }
                          //detail pemesanan

                          //detail pemesanan

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
                        SizedBox(height: 16.0),
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
      default:
        return Icons.museum;
    }
  }
}
