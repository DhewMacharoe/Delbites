import 'package:Delbites/services/database_service.dart';
import 'package:Delbites/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({Key? key}) : super(key: key);

  @override
  _DaftarPageState createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  final DatabaseService _databaseService = DatabaseService();
  String _otp = '';
  bool _isOtpSent = false;

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
      String username = _usernameController.text;
      String phoneNumber = _phoneController.text;
      User user = FirebaseAuth.instance.currentUser!;

      await _databaseService.saveUser(user.uid, phoneNumber, username);

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
      appBar: AppBar(title: Text('Daftar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
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
                Navigator.pushNamed(context, "/login");
              },
              child: Text("Sudah punya akun? Masuk"),
            ),
          ],
        ),
      ),
    );
  }
}
