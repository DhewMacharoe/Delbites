import 'package:Delbites/firebase_options.dart';
import 'package:Delbites/home.dart';
import 'package:Delbites/login.dart';
import 'package:Delbites/screens/payment/payment_status_pages.dart';
import 'package:Delbites/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Delbites/login_manual.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? "/home" : "/login",
      routes: {
        "/login": (context) => MasukPage(),
        '/login-manual': (context) => const LoginManualPage(),
        "/register": (context) => DaftarPage(),
        "/home": (context) => HomePage(),
        "/payment-success": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return PaymentSuccessPage(
            orderId: args['order_id'],
            transactionStatus: args['transaction_status'],
          );
        },
        "/payment-failed": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return PaymentFailedPage(
            orderId: args['order_id'],
          );
        },
      },
    );
  }
} 