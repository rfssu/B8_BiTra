import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_bitra/View/user/userPage.dart';
import 'package:project_bitra/controller/pesanan_controller.dart';
import 'package:project_bitra/model/model_pesanan.dart';

class FormPemesanan extends StatefulWidget {
  const FormPemesanan({super.key});

  @override
  State<FormPemesanan> createState() => _FormPemesananState();
}

class _FormPemesananState extends State<FormPemesanan> {
  var pesananController = PesananController();
  final formKey = GlobalKey<FormState>();
  String? nama;
  String? alamat;
  String? noHp;
  String? namaBarang;
  int jumlahBarang = 1;
  String? tanggal;
  String? status = "pending";
  String? selectedOption;
  List<String> options = ['Meja', 'Kursi', 'Sofa', 'Kasur', 'Almari'];

   final User? user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pesanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
                            ),
                    hintText: 'Masukan Nama',
                    labelText: ' Nama',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  onChanged: (value) {
                    setState(() {
                      nama = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
                            ),
                    hintText: 'Masukan Alamat',
                    labelText: 'Alamat',
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                  onChanged: (value) {
                    setState(() {
                      alamat = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
                            ),
                    hintText: 'Masukan Nomor HP',
                    labelText: 'Nomor HP',
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  onChanged: (value) {
                    setState(() {
                      noHp = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor HP harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Pilih Jenis Barang'),
                          content: DropdownButtonFormField<String>(
                            hint: const Text('data'),
                            value: selectedOption,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedOption = newValue;
                                namaBarang =
                                    newValue; // Perbarui nilai namaBarang
                              });
                              Navigator.of(context).pop();
                            },
                            items: options
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
                            ),
                        hintText: 'Masukan Nama Barang',
                        labelText: 'Nama Barang',
                        
                        prefixIcon: const Icon(Icons.shopping_cart),
                      ),
                      controller: TextEditingController(text: selectedOption),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama Barang Harus Di Isi';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
                            ),
                    hintText: 'Total Jumlah Barang',
                    labelText: 'Jumlah Barang',
                    prefixIcon: const Icon(Icons.format_list_numbered),
                  ),
                  onChanged: (value) {
                    setState(() {
                      jumlahBarang = int.parse(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Total Jumlah Barang harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    ).then((pickedDate) {
                      if (pickedDate != null) {
                        setState(() {
                          tanggal =
                              "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                        });
                      }
                    });
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
                            ),
                        hintText: 'Tanggal Pengambilan Barang',
                        labelText: 'Tanggal Barang Di ambil',
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(text: tanggal),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal Pengambilan Barang Harus Di Isi';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Konfirmasi'),
                              content: const Text(
                                  'Apakah Anda yakin ingin membatalkan?'),
                              actions: [
                                TextButton(
                                  child: const Text('Batal'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text('Ya'),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const UserHome(),
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
                    const SizedBox(width: 16),
                    ElevatedButton(
                      child: const Text('Add Pesanan'),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          PesananModel pm = PesananModel(
                              nama: nama!,
                              alamat: alamat!,
                              noHp: noHp!,
                              namaBarang: namaBarang!,
                              jumlahBarang: jumlahBarang,
                              tanggal: tanggal!,
                              status: status!,
                              uId: user!.uid
                              );
                          pesananController.addpesanan(pm);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pesanan Added')),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UserHome()), // Ganti HalamanTujuan dengan halaman yang ingin Anda reload
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
