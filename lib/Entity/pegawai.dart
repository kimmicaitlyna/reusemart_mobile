import 'dart:convert';

class Pegawai {
  String idPegawai;
  String idJabatan;
  String idDompet;
  String namaPegawai;
  DateTime tanggalLahir;
  String username;
  String password;

  Pegawai({
    required this.idPegawai,
    required this.idJabatan,
    required this.idDompet,
    required this.namaPegawai,
    required this.tanggalLahir,
    required this.username,
    required this.password,
  });

  factory Pegawai.fromRawJson(String str) => Pegawai.fromJson(json.decode(str));
  factory Pegawai.fromJson(Map<String, dynamic> json) => Pegawai(
        idPegawai: json["idPegawai"],
        idJabatan: json["idJabatan"],
        idDompet: json["idDompet"],
        namaPegawai: json["namaPegawai"],
        tanggalLahir: DateTime.parse(json["tanggalLahir"]),
        username: json["username"],
        password: json["password"],
        );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        'idPegawai': idPegawai,
        'idJabatan': idJabatan,
        'idDompet': idDompet,
        'namaPegawai': namaPegawai,
        'tanggalLahir': tanggalLahir.toIso8601String(),
        'username' : username,
        'password': password,
        };
}