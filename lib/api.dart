import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String key = "1234";
  static const String baseUrl = "http://taskreminder.atwebpages.com/api";

  static Future<Map<String, dynamic>> post(String file, Map<String, dynamic> body) async {
    body["key"] = key;
    final res = await http.post(
      Uri.parse("$baseUrl/$file"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> get(String file, Map<String, String> params) async {
    params["key"] = key;
    final uri = Uri.parse("$baseUrl/$file").replace(queryParameters: params);
    final res = await http.get(uri);
    return jsonDecode(res.body);
  }
}
