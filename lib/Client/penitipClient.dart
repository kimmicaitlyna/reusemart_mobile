import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class PenitipClient{
  // static const String baseUrl ='http://192.168.18.27/reusemart_mobile/public/api';
  // static const String baseUrl ='http://192.168.108.121:8000/api';
  // static const String baseUrl ='https://reusmart-test.store/api';
  static const String baseUrl ='http://192.168.18.27:8000/api';
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

   static Future<Map<String, dynamic>?>getData(String authToken) async {
    final url = Uri.parse('$baseUrl/penitip/getData');

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

  static Future<List<Map<String, dynamic>>?> getTopSeller(String authToken) async {
    final url = Uri.parse('$baseUrl/topSeller/get'); // Make sure baseUrl is properly set

    try {
      // Send the GET request with the Authorization header
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $authToken",  // Add the token in the header
          "Content-Type": "application/json",
        },
      );

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // If the 'data' field exists in the response and is a list, return it
        if (data != null && data['data'] != null) {
          print('Get data Response: ${data['data']}');
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          print('Error: No valid data field in the response.');
          return null;
        }
      } else {
        // Handle any other non-200 responses
        final errorData = jsonDecode(response.body);
        print('Failed to fetch data: ${errorData['message'] ?? 'Unknown error'}');
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error fetching top sellers: $e');
      throw Exception('Error: $e');
    }
  }

  static Future<bool> logout(String authToken) async {
    final url = Uri.parse('$baseUrl/penitip/logout');
    
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

  static Future<List<Map<String, dynamic>>?> getBarangByPenitip(String token, String idPenitip) async {
  final url = Uri.parse('$baseUrl/transaksi-penitipan/penitip/$idPenitip');

  try {
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == true && jsonData['data'] != null) {
        print('Barang by Penitip: ${jsonData['data']}');
        return List<Map<String, dynamic>>.from(jsonData['data']);
      } else {
        print('Gagal memuat barang: ${jsonData['message']}');
        return null;
      }
    } else {
      print('Response error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Exception error: $e');
    return null;
  }
}

}