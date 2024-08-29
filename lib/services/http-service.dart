import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haenreg_mobile/config/api-config.dart';

class HttpService {
  // Function to get the auth token from shared preferences
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Base function to construct the complete URL
  Uri _buildUri(String endpoint) {
    return Uri.parse('${ApiConfig.baseUrl}$endpoint');
  }

  // GET request
  Future<http.Response> get(String endpoint) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      _buildUri(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return _handleResponse(response);
  }

  // POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      _buildUri(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  // DELETE request
  Future<http.Response> delete(String endpoint) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      _buildUri(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return _handleResponse(response);
  }

  // Private method to handle and check the response status
  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception(
          'Request failed with status: ${response.statusCode}, body: ${response.body}');
    }
  }
}
