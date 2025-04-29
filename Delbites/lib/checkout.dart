import 'package:Delbites/services/midtrans_service.dart';
import 'package:Delbites/utils/payment_utils.dart';
import 'package:Delbites/waiting_page.dart';
import 'package:flutter/material.dart';
import 'package:Delbites/midtrans_payment_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> pesanan;

  const CheckoutPage({Key? key, required this.pesanan}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? selectedPayment;
  bool isLoading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  int getTotalHarga() {
    int total = 0;
    for (var item in widget.pesanan) {
      total +=
          (int.parse(item['price'].replaceAll('Rp ', '').replaceAll('.', '')) *
                  item['quantity'])
              .toInt();
    }
    return total;
  }

  Future<void> processPayment() async {
    if (selectedPayment == null) return;

    if (selectedPayment == "Bayar langsung di kasir") {
      processCashPayment();
    } else {
      await processMidtransPayment();
    }
  }

  void processCashPayment() {
    List<Map<String, String>> ordersToSend = widget.pesanan.map((item) {
      return {
        "name": item["name"].toString(),
        "price": item["price"].toString(),
        "quantity": item["quantity"].toString(),
        "date": "Sekarang",
        "status": "Menunggu",
        "payment": selectedPayment!,
      };
    }).toList();

    // Kosongkan keranjang
    setState(() {
      widget.pesanan.clear();
    });

    // Navigasi ke WaitingPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WaitingPage(orders: ordersToSend),
      ),
    );
  }

  Future<void> processMidtransPayment() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan isi nama dan email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 1. Generate Order ID
      final String orderId = PaymentUtils.generateOrderId();

      // 2. Ambil Total Harga
      final int totalHarga = getTotalHarga();

      // 3. Ambil daftar item dari pesanan
      final List<Map<String, dynamic>> itemsList = widget.pesanan.map((item) {
        return {
          'id': item['id'].toString(),
          'name': item['name'],
          'price': PaymentUtils.parseRupiah(item['price']),
          'quantity': item['quantity'],
        };
      }).toList();

      // 4. Pecah nama depan dan belakang
      final nameParts = PaymentUtils.splitName(nameController.text);

      // 5. Kirim ke backend Laravel
      final response = await http.post(
        Uri.parse('$baseUrl/api/midtrans/create-transaction'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'order_id': orderId.toString(),
          'gross_amount': totalHarga,
          'id_pemesanan': 1,
          'first_name': (nameParts['firstName'] ?? 'User').toString(),
          'last_name': (nameParts['lastName'] ?? '').toString(),
          'email': emailController.text,
          'items': itemsList,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        final String redirectUrl = result['redirect_url']?.toString() ?? '';
        final String orderId = result['order_id']?.toString() ?? '';

        // Buka halaman WebView pembayaran
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MidtransPaymentPage(
              redirectUrl: redirectUrl,
              orderId: orderId,
            ),
          ),
        );
      } else {
        throw Exception("Gagal membuat transaksi: ${response.body}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showCancelDialog(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Bayar',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2D5EA2),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _showCancelDialog(context),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pembayaran',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _paymentOption(
                              'Bayar langsung di kasir', Icons.store),
                          _paymentOption(
                              'Midtrans - Credit Card', Icons.credit_card),
                          _paymentOption('Midtrans - Bank Transfer',
                              Icons.account_balance),
                          _paymentOption('Midtrans - GoPay', Icons.payment),
                        ],
                      ),
                    ),
                    if (selectedPayment != null &&
                        selectedPayment != 'Bayar langsung di kasir')
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Customer Information',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'Pesanan',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.pesanan.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.fastfood, size: 40),
                              title: Text(widget.pesanan[index]['name']),
                              subtitle: Text(
                                '${widget.pesanan[index]['price']} x ${widget.pesanan[index]['quantity']}',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Harga',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          PaymentUtils.formatToRupiah(getTotalHarga()),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            selectedPayment == null ? null : processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedPayment == null
                              ? Colors.grey
                              : const Color(0xFF2D5EA2),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          selectedPayment == null
                              ? 'Pilih Pembayaran'
                              : 'Bayar dengan $selectedPayment',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _paymentOption(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selectedPayment == title
                  ? const Color(0xFF2D5EA2)
                  : Colors.grey,
              width: selectedPayment == title ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: const Color(0xFF2D5EA2)),
              const SizedBox(height: 5),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Batal Checkout"),
          content:
              const Text("Apakah anda yakin ingin membatalkan pembayaran?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Tidak"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }
}
