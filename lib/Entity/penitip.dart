import 'dart:convert';

class Penitip {
  String idPenitip ;
  String idTopSeller ;
  String idDompet ;
  int poin;
  String username;
  String password;
  String namaPenitip;
  String nik;
  String alamat;
  String email;

  Penitip({
    required this.idPenitip ,
    required this.idTopSeller,
    required this.idDompet,
    required this.poin,
    required this.username,
    required this.password,
    required this.namaPenitip,
    required this.nik,
    required this.alamat,
    required this.email,
  });

  factory Penitip.fromRawJson(String str) => Penitip.fromJson(json.decode(str));
  factory Penitip.fromJson(Map<String, dynamic> json) => Penitip(
        idPenitip : json["idPenitip "],
        idTopSeller: json["idTopSeller"],
        idDompet: json["idDompet"],
        poin: json["poin"],
        username: json["username"],
        password: json["password"],
        namaPenitip: json["namaPenitip"],
        nik : json["nik "],
        alamat: json["alamat"],
        email: json["email"],
        );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        'idPenitip ': idPenitip ,
        'idTopSeller': idTopSeller,
        'idDompet': idDompet,
        'poin': poin,
        'username': username,
        'password' : password,
        'namaPenitip': namaPenitip,
        'nik': nik,
        'alamat': alamat,
        'email': email,
        };
}