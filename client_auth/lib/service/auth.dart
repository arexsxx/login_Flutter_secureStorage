import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage();

// menyimpan acsess token ke secure storage
Future<void> login(String email, String password) async {
  final url = Uri.parse("http://192.168.43.212:8000/api/auth/login");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['token']['access_token'];

      await secureStorage.write(key: 'access_token', value: accessToken);
      print('Access token berhasil disimpan!');
    } else {
      final error = json.decode(response.body);
      throw Exception("Login gagal: ${error['message'] ?? 'Kesalahan server'}");
    }
  } catch (e) {
    throw Exception("Login gagal: $e");
  }
}

/// mengambil data menggunakan acsess token
Future<String> fetchProtectedData() async {
  final accessToken = await secureStorage.read(key: 'access_token');

  if (accessToken == null) {
    throw Exception("Access token tidak ditemukan. Silakan login ulang.");
  }

  final url = Uri.parse("http://192.168.43.212:8000/api/user/me");

  try {
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      return response.body; // mengembalikan data untuk ditampilkan ke UI
    } else if (response.statusCode == 401) {
      throw Exception(
          "Access token tidak valid atau expired. Silakan login ulang.");
    } else {
      final error = json.decode(response.body);
      throw Exception("Kesalahan: ${error['message'] ?? 'Kesalahan server'}");
    }
  } catch (e) {
    throw Exception("Terjadi kesalahan: $e");
  }
}

//menghapus acsess token
Future<void> logout() async {
  await secureStorage.delete(key: 'access_token');
  print("Access token berhasil dihapus.");
}
