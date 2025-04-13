import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _verificationId = '';

  Future<bool> sendOTP(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Error: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
      return true;
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  // Verifikasi OTP
  Future<bool> verifyOTP(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }

  // Registrasi User
  Future<bool> registerUser(
      String username, String phone, String password) async {
    try {
      await _firestore.collection('users').doc(phone).set({
        'username': username,
        'phone': phone,
        'password':
            password, // Simpan password dengan hashing di aplikasi nyata
      });
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Login User
  Future<bool> loginUser(String phone, String password) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(phone).get();
      if (userDoc.exists) {
        String savedPassword = userDoc['password'];
        if (savedPassword == password) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error logging in: $e');
      return false;
    }
  }
}
