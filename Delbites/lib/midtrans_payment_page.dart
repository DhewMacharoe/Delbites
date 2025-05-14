import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:Delbites/riwayat_pesanan.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://127.0.0.1:8000';

class MidtransPaymentPage extends StatefulWidget {
  final String redirectUrl;
  final String orderId;
  final List<Map<String, dynamic>> pesanan;
  final int idPelanggan;
  final int totalHarga;

  const MidtransPaymentPage({
    Key? key,
    required this.redirectUrl,
    required this.orderId,
    required this.pesanan,
    required this.idPelanggan,
    required this.totalHarga,
  }) : super(key: key);

  @override
  State<MidtransPaymentPage> createState() => _MidtransPaymentPageState();
}

class _MidtransPaymentPageState extends State<MidtransPaymentPage> {
  late WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });

            // Deteksi status pembayaran sukses atau gagal
            if (url.contains('transaction_status=settlement') ||
                url.contains('transaction_status=capture') ||
                url.contains('status_code=200')) {
              _handlePaymentSuccess();
            } else if (url.contains('transaction_status=deny') ||
                url.contains('transaction_status=cancel') ||
                url.contains('transaction_status=expire') ||
                url.contains('status_code=202')) {
              _handlePaymentFailure();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  Future<void> _handlePaymentSuccess() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('midtrans_order_id');
    prefs.remove('midtrans_redirect_url');

    try {
      // Kirim pemesanan ke backend Laravel
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/pemesanan'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'id_pelanggan': widget.idPelanggan,
          'total_harga': widget.totalHarga,
          'metode_pembayaran': 'transfer',
          'status': 'pembayaran',
          'detail_pemesanan': widget.pesanan.map((item) {
            final harga = item['price'] is int
                ? item['price']
                : int.tryParse(item['price']
                        .toString()
                        .replaceAll('Rp ', '')
                        .replaceAll('.', '')) ??
                    0;
            final qty = item['quantity'] is int
                ? item['quantity']
                : int.tryParse(item['quantity'].toString()) ?? 0;
            return {
              'id_menu': item['id_menu'],
              'jumlah': qty,
              'harga_satuan': harga,
              'subtotal': harga * qty,
            };
          }).toList(),
        }),
      );

      if (response.statusCode == 201) {
        // Hapus isi keranjang
        final clearCartResponse = await http.delete(
          Uri.parse('$baseUrl/api/keranjang/pelanggan/${widget.idPelanggan}'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        print("CLEAR CART STATUS: ${clearCartResponse.statusCode}");
        print("CLEAR CART RESPONSE: ${clearCartResponse.body}");

        // Redirect ke riwayat pesanan
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const RiwayatPesananPage()),
          (route) => false,
        );
      } else {
        throw Exception('Gagal menyimpan pesanan: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    }
  }

  Future<void> _handlePaymentFailure() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('midtrans_order_id');
    prefs.remove('midtrans_redirect_url');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pembayaran gagal atau dibatalkan.')),
    );

    Navigator.pop(context); // Kembali ke halaman sebelumnya (checkout)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2D5EA2),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Batalkan Pembayaran'),
                content: const Text('Yakin ingin membatalkan pembayaran ini?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tidak'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      Navigator.pop(context); // Tutup halaman Midtrans
                    },
                    child: const Text('Ya'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
