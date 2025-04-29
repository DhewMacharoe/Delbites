import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:Delbites/services/midtrans_service.dart';

class MidtransPaymentPage extends StatefulWidget {
  final String redirectUrl;
  final String orderId;

  const MidtransPaymentPage({
    Key? key,
    required this.redirectUrl,
    required this.orderId,
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

  void _handlePaymentSuccess() async {
    try {
      final response = await MidtransService.checkTransactionStatus(widget.orderId);
      Navigator.pushReplacementNamed(
        context, 
        '/payment-success',
        arguments: {
          'order_id': widget.orderId,
          'transaction_status': response['transaction_status'] ?? 'success',
        },
      );
    } catch (e) {
      Navigator.pushReplacementNamed(
        context, 
        '/payment-success',
        arguments: {
          'order_id': widget.orderId,
          'transaction_status': 'success',
        },
      );
    }
  }

  void _handlePaymentFailure() {
    Navigator.pushReplacementNamed(
      context, 
      '/payment-failed',
      arguments: {
        'order_id': widget.orderId,
      },
    );
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
                      Navigator.pop(context);
                      Navigator.pop(context);
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
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
