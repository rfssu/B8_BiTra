import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controller/pesanan_controller.dart';

class ProgresPesanan extends StatefulWidget {
  const ProgresPesanan({super.key});

  @override
  State<ProgresPesanan> createState() => _ProgresPesananState();
}

class _ProgresPesananState extends State<ProgresPesanan> {
  var cc = PesananController();

    final user = FirebaseAuth.instance.currentUser!;


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
    child : Scaffold(
      appBar: AppBar(
         title: const Text(
              'BiTra',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue.shade800,
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
                      String statusText = '';

                      if (status == 'pending') {
                        statusText = 'On Progress';
                      } else if (status == 'diterima') {
                        statusText = 'Diterima';
                      } else if (status == 'selesai') {
                        statusText = 'Selesai';
                      }

                      if (data[index]['uId'] == user.uid) {
                        if(status == 'selesai' || status == 'diterima' ){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
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
                                trailing: Text(
                                  statusText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: status == 'diterima'
                                        ? Colors.green
                                        : status == 'pending'
                                            ? const Color.fromARGB(255, 175, 13, 2)
                                            : Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                        }else {
                          return Container();
                        }
                      } else {
                        // Return an empty container if the status is neither "selesai" nor "diterima"
                        return Container();
                      }
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
