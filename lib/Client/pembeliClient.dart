import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class PembeliClient{
  // static const String baseUrl ='http://192.168.18.27/reusemart_mobile/public/api';
  // static const String baseUrl ='http://192.168.108.121:8000/api';
  // static const String baseUrl ='https://reusmart-test.store/api';
  static const String baseUrl ='http://192.168.255.121:8000/api';
  // static const String baseUrl ='http://10.0.2.2:8000/api';
  


  static Future<Map<String, dynamic>?> login(String username, String password) async {
  final url = Uri.parse('$baseUrl/pembeli/login');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final errorData = jsonDecode(response.body);
      print('Login failed: ${errorData['message'] ?? 'Unknown error'}');
      return null;
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

static Future<void> registerFcmToken(String authToken, String fcmToken) async {
    final url = Uri.parse('$baseUrl/pembeli/register-fcm-token');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'fcm_token': fcmToken}),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal registrasi FCM token');
    }
  }

  static Future<Map<String, dynamic>?>getData(String authToken) async {
    final url = Uri.parse('$baseUrl/pembeli/getData');

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Get data Response: $data');
        return data['data'];
      } else {
        final errorData = jsonDecode(response.body);
        print('Get data failed: ${errorData['message'] ?? 'Unknown error'}');
        return null;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> logout(String authToken) async {
    final url = Uri.parse('$baseUrl/pembeli/logout');
    
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>?> getRiwayatTransaksi(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pembeli/history'), // sesuaikan route jika berbeda
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      if (json['status'] == true) {
        return List<Map<String, dynamic>>.from(json['data']);
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil riwayat transaksi');
    }
  }

}