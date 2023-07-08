import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project_bitra/View/user/userPage.dart';
import 'package:project_bitra/model/model_pesanan.dart';

import '../../controller/pesanan_controller.dart';

class UpdatePesanan extends StatefulWidget {
  const UpdatePesanan(
      {super.key,
      this.id,
      this.beforenama,
      this.beforealamat,
      this.beforenoHp,
      this.beforeanamaBarang,
      this.beforejumlahBarang,
      this.beforetanggal,
      this.status,
      this.uId});

  final String? id;
  final String? beforenama;
  final String? beforealamat;
  final String? beforenoHp;
  final String? beforeanamaBarang;
  final int? beforejumlahBarang;
  final String? beforetanggal;
  final String? status;
  final String? uId;

  @override
  State<UpdatePesanan> createState() => _UpdatePesananState();
}

class _UpdatePesananState extends State<UpdatePesanan> {
  var pesananController = PesananController();
  final formkey = GlobalKey<FormState>();

  String? id;
  String? nama;
  String? alamat;
  String? noHp;
  String? namaBarang;
  int? jumlahBarang;
  String? tanggal;
  String? status;
  String? uId;

  String? selectedOption;
  List<String> options = ['Meja', 'Kursi', 'Sofa', 'Kasur', 'Almari'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Contact'),
      ),
      body: Padding(
        padding:const EdgeInsets.all(10),
        child : SingleChildScrollView(
        child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
                            ),
                    hintText: 'Nama',
                    labelText: 'Nama',
                    prefixIcon: Icon(Icons.person),
                  ),
                  onSaved: (value) {
                    nama = value;
                  },
                  initialValue: widget.beforenama,
                ),
                SizedBox(height: 20),
                TextFormField(
                  
                  decoration: InputDecoration(
                    border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
                            ),
                    hintText: 'Nomor HP',
                    labelText: 'Nomor HP',
                  
                    prefixIcon: Icon(Icons.phone),
                  ),
                  onSaved: (value) {
                    noHp = value;
                  },
                  initialValue: widget.beforenoHp,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
                            ),
                    hintText: 'Alamat',
                    labelText: 'Alamat Pengambilan',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  onSaved: (value) {
                    alamat = value;
                  },
                  initialValue: widget.beforealamat,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedOption ?? widget.beforeanamaBarang,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue;
                      namaBarang = newValue; // Perbarui nilai namaBarang
                    });
                  },
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
                            ),
                    hintText: 'Nama Barang',
                    labelText: 'Nama Barang',
                    prefixIcon: Icon(Icons.shopping_cart),
                  ),
                  onSaved: (value) {
                    namaBarang = value;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
                            ),
                    hintText: 'Jumlah Barang',
                    labelText: 'Jumlah Barang',
                    prefixIcon: Icon(Icons.format_list_numbered),
                  ),
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      jumlahBarang = int.parse(value);
                    }
                  },
                  initialValue: widget.beforejumlahBarang != null
                      ? widget.beforejumlahBarang.toString()
                      : '',
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
                            ),
                    hintText: 'Tanggal',
                    labelText: 'Tanggal Pengambilan',
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  readOnly: true,
                  controller: TextEditingController(
                    text: tanggal ?? widget.beforetanggal ?? '',
                  ),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      final String formattedDate =
                          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                      setState(() {
                        tanggal = formattedDate;
                      });
                    }
                  },
                  onSaved: (value) {
                    tanggal = value;
                  },
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text('Update Contact'),
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          formkey.currentState!.save();

                          PesananModel pm = PesananModel(
                            id: widget.id!,
                            nama: nama!,
                            alamat: alamat!,
                            noHp: noHp!,
                            namaBarang: namaBarang!,
                            jumlahBarang: jumlahBarang!,
                            tanggal: tanggal!,
                            status: widget.status,
                            uId: widget.uId
                          );

                          pesananController.updatePesanan(pm);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Contact Updated')));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserHome(),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      child: const Text('Cancel Update'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            )),),
      ),
    );
  }
}
