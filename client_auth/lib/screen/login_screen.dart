import 'package:flutter/material.dart';
import 'package:client_auth/service/auth.dart';
import 'package:client_auth/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? fetchedData; // Untuk menyimpan hasil fetch data

  void handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await login(_emailController.text, _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login berhasil!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleFetchData() async {
    try {
      final data = await fetchProtectedData();
      setState(() {
        fetchedData = data; // Simpan data ke state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data berhasil diambil: $data")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengambil data: $e")),
      );
    }
  }

  void handleHapusToken() async {
    try {
      await logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Access token berhasil dihapus!")),
      );

      // Navigasi ke layar login kosong
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false, // Hapus semua route sebelumnya
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus token: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: _isLoading ? "Loading..." : "Login",
              onPressed: _isLoading ? null : handleLogin,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Fetch Data",
              onPressed: handleFetchData,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Hapus Access Token",
              onPressed: handleHapusToken,
            ),
            const SizedBox(height: 20),
            if (fetchedData != null) // Tampilkan data jika tersedia
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hasil Fetch Data:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    fetchedData!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
