import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';


class MerchClient {
  // static const String baseUrl ='http://192.168.18.27/reusemart_mobile/public/api';
  static const String baseUrl ='https://reusmart-test.store/api';
//  static const String baseUrl ='http://192.168.18.27:8000/api';
  // static const String baseUrl ='http://127.0.0.1:8000/api';
  // static const String baseUrl ='http://10.0.2.2:8000/api'; 

  /// Fetches the merchandise list from the API and returns a List of Map<String, dynamic>
  static Future<List<Map<String, dynamic>>> showMerch() async {
    final url = Uri.parse('$baseUrl/getMerch');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Ensure each item is a Map<String, dynamic>
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load merchandise');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }



}