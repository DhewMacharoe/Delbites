import 'package:Delbites/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:Delbites/services/auth_services.dart';

class MasukPage extends StatefulWidget {
  const MasukPage({Key? key}) : super(key: key);

  @override
  _MasukPageState createState() => _MasukPageState();
}

class _MasukPageState extends State<MasukPage> {
  final _phoneController = TextEditingController();
  String _otp = '';
  String _verificationId = '';
  bool _isOtpSent = false;

  final FirebaseService _firebaseService = FirebaseService();

  void _sendOtp() async {
    String phoneNumber = _phoneController.text.trim();

    // Kirim OTP dan simpan verificationId dari Firebase
    await _firebaseService.sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) {
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
        });
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal kirim OTP: $error')),
        );
      },
    );
  }

  void _verifyOtp() async {
    final success = await AuthService.verifyOTPAndLogin(
      otp: _otp,
      phone: _phoneController.text.trim(),
      verificationId: _verificationId,
      nama: '', // kosong saat login
    );

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login gagal. Periksa OTP atau nomor HP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Masuk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
            if (_isOtpSent)
              TextField(
                onChanged: (value) {
                  setState(() {
                    _otp = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Kode OTP'),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
              child: Text(_isOtpSent ? 'Verifikasi OTP' : 'Kirim OTP'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
              child: const Text("Belum punya akun? Daftar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/login-manual");
              },
              child: const Text("Login dengan password"),
            ),
          ],
        ),
      ),
    );
  }
}
