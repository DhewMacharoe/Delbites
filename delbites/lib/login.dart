import 'package:Delbites/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MasukPage extends StatefulWidget {
  const MasukPage({Key? key}) : super(key: key);

  @override
  _MasukPageState createState() => _MasukPageState();
}

class _MasukPageState extends State<MasukPage> {
  final _phoneController = TextEditingController();
  String _otp = '';
  bool _isOtpSent = false;
  final FirebaseService _firebaseService = FirebaseService();

  void _sendOtp() async {
    String phoneNumber = _phoneController.text;
    bool success = await _firebaseService.sendOTP(phoneNumber);

    if (success) {
      setState(() {
        _isOtpSent = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to send OTP. Please try again.'),
      ));
    }
  }

  void _verifyOtp() async {
  bool success = await _firebaseService.verifyOTP(_otp);

  if (success) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // simpan status login

    Navigator.pushReplacementNamed(context, "/home");
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('OTP verification failed. Please try again.'),
    ));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Masuk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
            if (_isOtpSent)
              TextField(
                onChanged: (value) {
                  setState(() {
                    _otp = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Kode OTP'),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
              child: Text(_isOtpSent ? 'Verifikasi OTP' : 'Kirim OTP'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
              child: Text("Belum punya akun? Daftar"),
            ),
          ],
        ),
      ),
    );
  }
}
