import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/carbon_credit.dart';
import '../models/transaction.dart';

class ApiService {
  static String _baseUrl = 'http://localhost:5000/api';
  static String? _token;

  static void setBaseUrl(String url) {
    _baseUrl = url;
  }

  static void setToken(String token) {
    _token = token;
  }

  static Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      if (_token != null && _token!.isNotEmpty) 'Authorization': 'Bearer $_token',
    };
  }

  // Auth endpoints
  static Future<Map<String, dynamic>> register(User user, String password) async {
    print('Registering user...${user.toJson()}');
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode({
        ...user.toJson(),
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Carbon Credit endpoints
  static Future<List<CarbonCredit>> getCarbonCredits() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/carbon-credits'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      print("Data: $data");
      return data.map((json) => CarbonCredit.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch carbon credits: ${response.body}');
    }
  }

  static Future<CarbonCredit> createCarbonCredit(CarbonCredit credit) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/carbon-credits'),
      headers: _headers,
      body: jsonEncode(credit.toJson()),
    );

    if (response.statusCode == 201) {
      return CarbonCredit.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to create carbon credit: ${response.body}');
    }
  }

  static Future<void> buyCarbonCredit(String creditId, int credits) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/carbon-credits/$creditId/buy'),
      headers: _headers,
      body: jsonEncode({'credits': credits}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to buy carbon credits: ${response.body}');
    }
  }

  // Profile endpoints
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/profile'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to fetch profile: ${response.body}');
    }
  }

  static Future<void> updateProfile(User user) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/profile'),
      headers: _headers,
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  static Future<List<Transaction>> getTransactionHistory() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/profile/transactions'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch transaction history: ${response.body}');
    }
  }
} 