import 'package:flutter/material.dart';
import 'package:Delbites/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginManualPage extends StatefulWidget {
  const LoginManualPage({Key? key}) : super(key: key);

  @override
  State<LoginManualPage> createState() => _LoginManualPageState();
}

class _LoginManualPageState extends State<LoginManualPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  void _loginManual() async {
    setState(() => isLoading = true);

    final noHp = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    final result = await AuthService.loginManual(noHp, password);

    setState(() => isLoading = false);

    if (result['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('id_pelanggan', result['id_pelanggan']);
      await prefs.setString('nama', result['nama']);
      await prefs.setString('no_hp', result['no_hp']);

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Manual")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'No. HP'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _loginManual,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Masuk"),
            ),
          ],
        ),
      ),
    );
  }
}
