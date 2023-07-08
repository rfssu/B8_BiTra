// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PesananModel {

    String? id;
    final String nama;
    final String alamat;
    final String noHp;
    final String namaBarang;
    final int jumlahBarang;
    final String tanggal;
    String? status;
    String? uId;
  PesananModel({
    this.id,
    required this.nama,
    required this.alamat,
    required this.noHp,
    required this.namaBarang,
    required this.jumlahBarang,
    required this.tanggal,
    this.status,
    this.uId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'noHp': noHp,
      'namaBarang': namaBarang,
      'jumlahBarang': jumlahBarang,
      'tanggal': tanggal,
      'status': status,
      'uId': uId,
    };
  }

  factory PesananModel.fromMap(Map<String, dynamic> map) {
    return PesananModel(
      id: map['id'] != null ? map['id'] as String : null,
      nama: map['nama'] as String,
      alamat: map['alamat'] as String,
      noHp: map['noHp'] as String,
      namaBarang: map['namaBarang'] as String,
      jumlahBarang: map['jumlahBarang'] as int,
      tanggal: map['tanggal'] as String,
      status: map['status'] != null ? map['status'] as String : null,
      uId: map['uId'] != null ? map['uId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PesananModel.fromJson(String source) => PesananModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
