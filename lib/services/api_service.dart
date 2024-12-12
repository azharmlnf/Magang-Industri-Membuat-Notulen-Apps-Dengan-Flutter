import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // Register
  Future<Map<String, dynamic>?> register(
      String email, String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': email, 'username': username, 'password': password},
    );
    return _handleResponse(response);
  }

  // Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': email, 'password': password},
    );
    return _handleResponse(response);
  }

//dashboard
Future<Map<String, dynamic>?> getAgendas(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/dashboard-list-agenda'),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    print('Failed to fetch agendas: ${response.statusCode}');
    print('Response Data: $response');

    return null;
  }
}


  // Get Profile
  Future<Map<String, dynamic>?> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

  // Logout
  Future<Map<String, dynamic>?> logout(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

  // Agenda List
  Future<Map<String, dynamic>?> listAgenda(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/list-agenda'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

  // Add Agenda
  Future<Map<String, dynamic>?> addAgenda(
      String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add-agenda'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Update Agenda
  Future<Map<String, dynamic>?> updateAgenda(
      String token, int agendaId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-agenda/$agendaId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Delete Agenda
  Future<Map<String, dynamic>?> deleteAgenda(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete-agenda/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

  // List Departemen
  Future<Map<String, dynamic>?> listDepartemen(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/list-departemen'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

  // Add Departemen
  Future<Map<String, dynamic>?> addDepartemen(
      String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add-departemen'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Update Departemen
  Future<Map<String, dynamic>?> updateDepartemen(
      String token, int departemenId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-departemen/$departemenId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Delete Departemen
  Future<Map<String, dynamic>?> deleteDepartemen(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete-departemen/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

//notulen
  // List Notulens
  Future<Map<String, dynamic>?> listNotulen(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/list-notulen'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

//add notulen
  Future<Map<String, dynamic>?> addNotulen(
      String token, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add-notulen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add notulen');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update Notulen
  Future<Map<String, dynamic>> updateNotulen(
      String token, int notulenId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-notulen/$notulenId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update notulen');
    }
  }

  // Delete Notulen
  static Future<Map<String, dynamic>?> deleteNotulen(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete-notulen/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception("Gagal menghapus notulen: $e");
    }
  }

//personil
//list
  Future<Map<String, dynamic>?> listPersonil(String token, int agendaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/list-personil/$agendaId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return _handleResponse(
          response); // Gunakan fungsi _handleResponse untuk menangani respons
    } catch (e) {
      print("Error fetching personil: $e");
      return null;
    }
  }

//delete
  static Future<Map<String, dynamic>?> deletePersonil(
      int agendaUserId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete-personil/$agendaUserId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return _handleResponse(
          response); // Gunakan fungsi _handleResponse untuk menangani respons
    } catch (e) {
      print("Error deleting personil: $e");
      return null;
    }
  }

  // Add Personil
  Future<Map<String, dynamic>?> addPersonil(
      String token, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add-personil'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add personil');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>?> updatePersonil(
      String token, int personilId, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/update-personil/$personilId");
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    print("URL: $url");
    print("Headers: $headers");
    print("Body: $data");

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update personil: ${response.body}");
    }
  }

//mendapat id personil
  Future<Map<String, dynamic>?> getPersonilById(
      String token, int personilId) async {
    final url = Uri.parse("$baseUrl/personil/$personilId");
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception("Failed to load personil");
      }
    } catch (e) {
      print("Exception caught: $e");
      throw Exception("Failed to load personil");
    }
  }

  // Response Handler
  static Map<String, dynamic>? _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return {'error': 'An error occurred: ${response.body}'};
    }
  }
}
