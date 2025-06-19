import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';


class UmumClient {
  // static const String baseUrl ='http://192.168.18.27/reusemart_mobile/public/api';
  static const String baseUrl ='http://192.168.7.109:8000/api';
  // static const String baseUrl ='http://127.0.0.1:8000/api';
  // static const String baseUrl ='http://10.0.2.2:8000/api'; 

static Future<List<dynamic>> ShowUmumBarang() async {
  final url = Uri.parse('$baseUrl/show-umum-barang');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  } else {
    throw Exception('Failed to load barang umum');
  }
}




}