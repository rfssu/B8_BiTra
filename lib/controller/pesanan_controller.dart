import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_bitra/model/model_pesanan.dart';

class PesananController {
  final pesananCollection = FirebaseFirestore.instance.collection('pesanan');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future addpesanan(PesananModel modelPesanan) async {
    final pesanan = modelPesanan.toMap();

    final DocumentReference docRef = await pesananCollection.add(pesanan);

    final String docId = docRef.id;

    final PesananModel pesananModel = PesananModel(
        id: docId,
        nama:modelPesanan.nama,
        alamat:modelPesanan.alamat,
        noHp:modelPesanan.noHp,
        namaBarang:modelPesanan.namaBarang,
        jumlahBarang:modelPesanan.jumlahBarang,
        tanggal:modelPesanan.tanggal);

    await docRef.update(pesananModel.toMap());
  }
   Future getPesanan() async {
    final pesanan = await pesananCollection.get();
    streamController.sink.add(pesanan.docs);

    return pesanan.docs;
  }

  Future hapusPesanan(String id) async {
    final pesanan = await pesananCollection.doc(id).delete();
    return pesanan;
  }
}
