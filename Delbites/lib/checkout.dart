import 'dart:convert';

import 'package:Delbites/midtrans_payment_page.dart';
import 'package:Delbites/utils/payment_utils.dart';
import 'package:Delbites/waiting_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://127.0.0.1:8000'; // Tambahkan definisi baseUrl

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
  final TextEditingController phoneController = TextEditingController();

  int getTotalHarga() {
    int total = 0;
    for (var item in widget.pesanan) {
      // Perbaikan untuk menangani price sebagai integer
      int price = 0;
      int quantity = 0;

      // Handle berbagai kemungkinan tipe data untuk price
      if (item['price'] is int) {
        price = item['price'];
      } else if (item['price'] is String) {
        // Coba parse string ke int
        price = int.tryParse(item['price']
                .toString()
                .replaceAll('Rp ', '')
                .replaceAll('.', '')) ??
            0;
      }

      // Handle berbagai kemungkinan tipe data untuk quantity
      if (item['quantity'] is int) {
        quantity = item['quantity'];
      } else {
        quantity = int.tryParse(item['quantity'].toString()) ?? 0;
      }

      total += price * quantity;
    }
    return total;
  }

  // Format harga untuk ditampilkan
  String formatPrice(dynamic price) {
    if (price is int) {
      return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
    } else if (price is String) {
      if (price.startsWith('Rp ')) {
        return price;
      } else {
        return 'Rp $price';
      }
    }
    return 'Rp 0';
  }

  Future<void> processPayment() async {
    final nama = nameController.text.trim();
    final telepon = phoneController.text.trim();
    final email = emailController.text.trim();

    if (nama.isEmpty || telepon.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data pelanggan.')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // 1. Panggil API pelanggan
      final pelangganResponse = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/pelanggan'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nama': nama, 'telepon': telepon}),
      );

// Debug output
      print('Status: ${pelangganResponse.statusCode}');
      print('Body: ${pelangganResponse.body}');

      if (pelangganResponse.statusCode != 200 &&
          pelangganResponse.statusCode != 201) {
        throw Exception('Gagal ambil pelanggan');
      }

// Cek jika body kosong
      if (pelangganResponse.body.trim().isEmpty) {
        throw Exception('Respons dari server kosong.');
      }

      Map<String, dynamic> pelangganData;
      try {
        pelangganData = jsonDecode(pelangganResponse.body.trim());
      } catch (e) {
        throw Exception('Gagal decode pelangganResponse.body: $e');
      }

      final idPelanggan = pelangganData['id'];

      // 2. Persiapkan data pesanan
      final orderId = 'ORDER-${DateTime.now().millisecondsSinceEpoch}';
      final grossAmount = getTotalHarga();

      final items = widget.pesanan
          .map((item) => {
                'id': item['id'].toString(),
                'name': item['name'],
                'price': item['price'],
                'quantity': item['quantity'],
              })
          .toList();

      // 3. Kirim ke API Midtrans
      final response = await http.post(
        Uri.parse('$baseUrl/api/midtrans/create-transaction'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'id_pelanggan': idPelanggan,
          'order_id': orderId,
          'gross_amount': grossAmount,
          'first_name': nama,
          'last_name': '',
          'email': email,
          'items': items,
        }),
      );

      if (response.headers['content-type']?.contains('application/json') ==
          true) {
        final midtransData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          final String redirectUrl = result['redirect_url'] ?? '';
          final String orderId = result['order_id'] ?? '';

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
          throw Exception(
              'Gagal membuat transaksi: ${midtransData['message']}');
        }
      } else {
        print("Respons bukan JSON:\n${response.body}");
        throw Exception(
            'Server mengembalikan HTML atau format tidak dikenali.');
      }
    } catch (e) {
      print("Payment error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void processCashPayment() {
    List<Map<String, String>> ordersToSend = widget.pesanan.map((item) {
      return {
        "name": item["name"].toString(),
        "price": formatPrice(item["price"]),
        "quantity": item["quantity"].toString(),
        "date": "Sekarang",
        "status": "Menunggu",
        "payment": selectedPayment!,
        // Tambahkan informasi suhu dan catatan jika ada
        if (item["suhu"] != null) "suhu": item["suhu"].toString(),
        if (item["catatan"] != null && item["catatan"].isNotEmpty)
          "catatan": item["catatan"].toString(),
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
      final String nama = nameController.text.trim();

      // 1. Generate Order ID
      final String orderId = PaymentUtils.generateOrderId();

      // 2. Ambil Total Harga
      final int totalHarga = getTotalHarga();

      // 3. Ambil daftar item dari pesanan
      final List<Map<String, dynamic>> itemsList = widget.pesanan.map((item) {
        int price = 0;
        if (item['price'] is int) {
          price = item['price'];
        } else if (item['price'] is String) {
          price = int.tryParse(item['price']
                  .toString()
                  .replaceAll('Rp ', '')
                  .replaceAll('.', '')) ??
              0;
        }

        return {
          'id': item['id'].toString(),
          'name': item['name'],
          'price': price,
          'quantity': item['quantity'],
          if (item['suhu'] != null) 'suhu': item['suhu'],
          if (item['catatan'] != null && item['catatan'].isNotEmpty)
            'catatan': item['catatan'],
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
          'id_pelanggan':
              nama, // <-- ini harus hasil dari step simpan/cari pelanggan sebelumnya
          'order_id': orderId.toString(),
          'gross_amount': totalHarga,
          'first_name': nameParts[0],
          'last_name':
              nameParts.length > 1 ? nameParts.sublist(1).join(" ") : '',
          'email': "no@email.com", // tetap dummy
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
  void initState() {
    super.initState();

    // Ambil nama pelanggan dari SharedPreferences
    _getCustomerName();
  }

  void _getCustomerName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('nama_pelanggan');

    // Setel nama pelanggan ke dalam nameController
    if (name != null) {
      nameController.text = name; // Isi nama pelanggan di TextField
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
                          _paymentOption('Bank Transfer', Icons.credit_card),
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
                              controller: phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Nomor WhatsApp',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: nameController, // Nama sudah otomatis
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true, // Membaca saja, tidak bisa diedit
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
                          final item = widget.pesanan[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading:
                                        const Icon(Icons.fastfood, size: 40),
                                    title: Text(item['name']),
                                    subtitle: Text(
                                      '${formatPrice(item['price'])} x ${item['quantity']}',
                                    ),
                                  ),
                                  if (item['suhu'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, bottom: 8.0),
                                      child: Text(
                                        'Suhu: ${item['suhu']}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  if (item['catatan'] != null &&
                                      item['catatan'].isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, bottom: 8.0),
                                      child: Text(
                                        'Catatan: ${item['catatan']}',
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                ],
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
