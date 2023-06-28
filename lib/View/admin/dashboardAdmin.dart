import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../controller/aut_controller.dart';
import '../../controller/pesanan_controller.dart';
import 'konfirmasi.dart';

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

  
  @override
  void initState() {
    super.initState();
    cc.getPesanan();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          // onLongPress: () {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => UpdateContact(
                          //                 beforenama:
                          //                     data[index]['name'].toString(),
                          //                 beforephone:
                          //                     data[index]['phone'].toString(),
                          //                 beforeemail:
                          //                     data[index]['email'].toString(),
                          //                 beforeaddress:
                          //                     data[index]['address'].toString(),
                          //                 id: data[index]['id'].toString(),
                          //               )));
                          // },
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
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(data[index]['nama']),
                              subtitle: Text(data[index]['noHp']),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  cc
                                      .hapusPesanan(
                                          data[index]['id'].toString())
                                      .then((value) {
                                    setState(() {
                                      cc.getPesanan();
                                    });
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Contact Deleted')));
                                },
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
      )
    );
  }
  }



