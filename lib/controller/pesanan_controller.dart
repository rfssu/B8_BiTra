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
        nama: modelPesanan.nama,
        alamat: modelPesanan.alamat,
        noHp: modelPesanan.noHp,
        namaBarang: modelPesanan.namaBarang,
        jumlahBarang: modelPesanan.jumlahBarang,
        tanggal: modelPesanan.tanggal,
        status: modelPesanan.status,
        uId: modelPesanan.uId);

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

  Future acceptPesanan(String id) async {
    await pesananCollection.doc(id).update({
      'status': 'diterima',
    });
  }

  Future pesananSelesai(String id) async {
    await pesananCollection.doc(id).update({
      'status': 'selesai',
    });
  }

  Future getPesananById(String id) async {
    try {
      DocumentSnapshot snapshot = await pesananCollection.doc(id).get();
      return snapshot;
    } catch (e) {
      print('Error getting pesanan by ID: $e');
      throw e;
    }
  }

  Future updatePesanan(PesananModel pesananModel) async {
    final PesananModel pesanModel = PesananModel(
      id: pesananModel.id,
      nama: pesananModel.nama,
      alamat: pesananModel.alamat,
      noHp: pesananModel.noHp,
      namaBarang: pesananModel.namaBarang,
      jumlahBarang: pesananModel.jumlahBarang,
      tanggal: pesananModel.tanggal,
      status: pesananModel.status,
      uId: pesananModel.uId // Tetapkan status yang ada sebelumnya
    );
    await pesananCollection.doc(pesananModel.id).update(pesananModel.toMap());
    await getPesanan();
  }
  
}
