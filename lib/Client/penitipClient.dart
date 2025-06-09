import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class PenitipClient{
  // static const String baseUrl ='http://192.168.18.27/reusemart_mobile/public/api';
  static const String baseUrl ='http://192.168.18.27:8000/api';
  // static const String baseUrl ='http://127.0.0.1:8000/api';
  // static const String baseUrl ='http://10.0.2.2:8000/api';


  static Future<Map<String, dynamic>?> login(String username, String password) async {
  final url = Uri.parse('$baseUrl/penitip/login');

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
    final url = Uri.parse('$baseUrl/penitip/register-fcm-token');

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

}