import 'dart:convert';

class Pembeli {
  String idPembeli;
  String username;
  String password;
  int poin;
  String namaPembeli;
  String email;


  Pembeli({
    required this.idPembeli,
    required this.username,
    required this.password,
    required this.poin,
    required this.namaPembeli,
    required this.email,
  });

  factory Pembeli.fromRawJson(String str) => Pembeli.fromJson(json.decode(str));
  factory Pembeli.fromJson(Map<String, dynamic> json) => Pembeli(
        idPembeli: json["idPembeli"],
        username: json["username"],
        password: json["password"],
        poin: json["poin"],
        namaPembeli:json["namaPembeli"],
        email: json["email"],

        );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        'idPembeli': idPembeli,
        'username': username,
        'password': password,
        'poin': poin,
        'namaPembeli': namaPembeli,
        'email' : email,

        };
}