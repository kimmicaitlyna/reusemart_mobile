import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class PegawaiClient{
  // static const String baseUrl ='http://192.168.18.27/reusemart_mobile/public/api';
  // static const String baseUrl ='http://192.168.108.121:8000/api';
  // static const String baseUrl ='https://reusmart-test.store/api';
  static const String baseUrl ='http://192.168.18.27:8000/api';
  // static const String baseUrl ='http://127.0.0.1:8000/api';
  // static const String baseUrl ='http://10.0.2.2:8000/api';   //emulator


  static Future<Map<String, dynamic>?> login(String username, String password) async {
  final url = Uri.parse('$baseUrl/pegawai/login');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Login Response: $data');
      return data;
    } else {
      final errorData = jsonDecode(response.body);
      print('Login failed: ${errorData['message'] ?? 'Unknown error'}');
      return null;
    }
  } catch (e) {
    throw Exception('Error: $e');
    throw Exception('Gagal koneksi ke server');
  }
}

static Future<void> registerFcmToken(String authToken, String fcmToken) async {
    final url = Uri.parse('$baseUrl/pegawai/register-fcm-token');

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

  static Future<Map<String, dynamic>?> getData(String authToken) async {
    final url = Uri.parse('$baseUrl/pegawai/getData');

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
    final url = Uri.parse('$baseUrl/pegawai/logout');
    
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
  static Future<List<dynamic>> getHistoriKomisiHunter(String authToken) async {
  // Step 1: Get user data to extract idPegawai
  final userData = await getData(authToken);
  if (userData == null || userData['idPegawai'] == null) {
    throw Exception('idPegawai tidak ditemukan');
  }
  final idPegawai = userData['idPegawai'];

  // Step 2: Call the histori-komisi-hunter API
  final url = Uri.parse('$baseUrl/histori-komisi-hunter/$idPegawai');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  } else {
    throw Exception('Gagal mengambil histori komisi');
  }
}

  static Future<Map<String, dynamic>?> getHistoryKurir(String authToken) async {
    final url = Uri.parse('$baseUrl/getHistory');

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
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        print('Get data failed: ${errorData['message'] ?? 'Unknown error'}');
        return null;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Map<String, dynamic>?> getPengiriman(String authToken) async {
    final url = Uri.parse('$baseUrl/getPengiriman');

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
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        print('Get data failed: ${errorData['message'] ?? 'Unknown error'}');
        return null;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Map<String, dynamic>?> updateStatus(String authToken, String noNota) async {
    final url = Uri.parse('$baseUrl/updatePengiriman/$noNota');

    try {
      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Get data Response: $data');
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        print('Get data failed: ${errorData['message'] ?? 'Unknown error'}');
        return null;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

}