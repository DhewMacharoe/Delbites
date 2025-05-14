import 'dart:convert';
import 'dart:io';

import 'package:Delbites/midtrans_payment_page.dart';
import 'package:Delbites/utils/payment_utils.dart';
import 'package:Delbites/waiting_page.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://127.0.0.1:8000';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> pesanan;
  final int idPelanggan;
  final int totalHarga;

  const CheckoutPage({
    Key? key,
    required this.pesanan,
    required this.idPelanggan,
    required this.totalHarga,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

List<Map<String, dynamic>> buildDetailPemesanan(
    List<Map<String, dynamic>> pesanan) {
  return pesanan.map((item) {
    final int harga = (item['price'] is int)
        ? item['price']
        : int.tryParse(item['price']
                .toString()
                .replaceAll('Rp ', '')
                .replaceAll('.', '')) ??
            0;

    final int qty = (item['quantity'] is int)
        ? item['quantity']
        : int.tryParse(item['quantity'].toString()) ?? 0;

    return {
      'id_menu': item['id_menu'],
      'jumlah': qty,
      'harga_satuan': harga,
      'subtotal': harga * qty,
      'catatan': item['catatan'] ?? '',
      'suhu': item['suhu'] ?? '',
    };
  }).toList();
}

Future<String> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final info = await deviceInfo.androidInfo;
    return info.id;
  } else if (Platform.isIOS) {
    final info = await deviceInfo.iosInfo;
    return info.identifierForVendor ?? '';
  }
  return '';
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
      final prefs = await SharedPreferences.getInstance();

      // 1. Panggil API pelanggan
      final int idPelanggan = await getOrCreatePelangganId(nama, telepon);
      final grossAmount = getTotalHarga();
      // 2. Cek apakah sudah ada transaksi Midtrans yang aktif
      final existingOrderId = prefs.getString('midtrans_order_id');
      final existingRedirectUrl = prefs.getString('midtrans_redirect_url');

      if (existingOrderId != null && existingRedirectUrl != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MidtransPaymentPage(
              redirectUrl: existingRedirectUrl,
              orderId: existingOrderId,
              pesanan: widget.pesanan,
              idPelanggan: idPelanggan,
              totalHarga: grossAmount,
            ),
          ),
        );
        return;
      }

      // 3. Persiapkan data pesanan
      final orderId = 'ORDER-${DateTime.now().millisecondsSinceEpoch}';

      final items = widget.pesanan
          .map((item) => {
                'id': item['id_menu'].toString(),
                'name': item['name'],
                'price': item['price'],
                'quantity': item['quantity'],
              })
          .toList();

      // 4. Kirim ke API Midtrans
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
          'last_name': '(Del)',
          'email': email,
          'items': items,
        }),
      );

      if (response.headers['content-type']?.contains('application/json') ==
          true) {
        final result = jsonDecode(response.body);

        if (response.statusCode == 200) {
          final String redirectUrl = result['redirect_url'] ?? '';
          final String orderId = result['order_id'] ?? '';

          // ✅ Simpan data transaksi ke local storage
          await prefs.setString('midtrans_order_id', orderId);
          await prefs.setString('midtrans_redirect_url', redirectUrl);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MidtransPaymentPage(
                redirectUrl: redirectUrl,
                orderId: orderId,
                pesanan: widget.pesanan,
                idPelanggan: idPelanggan,
                totalHarga: grossAmount,
              ),
            ),
          );
        } else {
          throw Exception('Gagal membuat transaksi: ${result['message']}');
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

  Future<int> getOrCreatePelangganId(String nama, String telepon) async {
    final prefs = await SharedPreferences.getInstance();

    // Cek jika id_pelanggan sudah disimpan
    final existingId = prefs.getInt('id_pelanggan');
    if (existingId != null) return existingId;

    // Ambil device ID
    final deviceId = await getDeviceId();

    // Simpan device ID kalau belum disimpan
    if (!prefs.containsKey('device_id')) {
      await prefs.setString('device_id', deviceId);
    }

    // Cek ke backend apakah pelanggan dengan device_id sudah ada
    final checkResponse = await http.get(
      Uri.parse('$baseUrl/api/pelanggan/by-device?device_id=$deviceId'),
    );

    if (checkResponse.statusCode == 200) {
      final data = jsonDecode(checkResponse.body);
      await prefs.setInt('id_pelanggan', data['id']);
      await prefs.setString('nama_pelanggan', data['nama']);
      await prefs.setString('telepon_pelanggan', data['telepon']);
      return data['id'];
    }

    // Jika belum ada, buat pelanggan baru
    final createResponse = await http.post(
      Uri.parse('$baseUrl/api/pelanggan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nama,
        'telepon': telepon,
        'device_id': deviceId,
      }),
    );

    final created = jsonDecode(createResponse.body);
    final id = created['id'];
    await prefs.setInt('id_pelanggan', id);
    await prefs.setString('nama_pelanggan', nama);
    await prefs.setString('telepon_pelanggan', telepon);
    return id;
  }

  Future<void> processCashPayment() async {
    setState(() => isLoading = true);
    try {
      final nama = nameController.text.trim();
      final telepon = phoneController.text.trim();

      if (nama.isEmpty || telepon.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama dan nomor WhatsApp wajib diisi.')),
        );
        setState(() => isLoading = false);
        return;
      }

      final idPelanggan = await getOrCreatePelangganId(nama, telepon);

      // 1. Kirim ke API pemesanan
      final response = await http.post(
        Uri.parse('$baseUrl/api/pemesanan'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'id_pelanggan': idPelanggan,
          'admin_id': null,
          'total_harga': getTotalHarga(),
          'metode_pembayaran': 'tunai',
          'status': 'menunggu',
          'waktu_pengambilan': DateTime.now().toIso8601String(),
          'detail_pemesanan': buildDetailPemesanan(widget.pesanan),
        }),
      );
      print('⏳ Sending pemesanan data:');
      print(jsonEncode({
        'id_pelanggan': idPelanggan,
        'admin_id': null,
        'total_harga': getTotalHarga(),
        'metode_pembayaran': 'tunai',
        'status': 'menunggu',
        'waktu_pengambilan': DateTime.now().toIso8601String(),
        'detail_pemesanan': buildDetailPemesanan(widget.pesanan),
      }));

      if (response.statusCode == 201) {
        // 2. Hapus keranjang setelah pemesanan berhasil
        await http.delete(
          Uri.parse('$baseUrl/api/keranjang/pelanggan/$idPelanggan'),
          headers: {'Content-Type': 'application/json'},
        );

        // 3. Navigasi ke halaman menunggu
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingPage(orders: widget.pesanan),
          ),
        );
      } else {
        throw Exception('Gagal menyimpan pesanan: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal bayar: $e')));
    } finally {
      setState(() => isLoading = false);
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
    final phone = prefs.getString('telepon_pelanggan');

    // Setel nama pelanggan ke dalam nameController
    if (name != null) {
      nameController.text = name;
    }
    if (phone != null) {
      phoneController.text = phone;
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
                          _paymentOption('Bayar Non-Tunai', Icons.credit_card),
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
                        onPressed: selectedPayment == null
                            ? null
                            : selectedPayment == 'Bayar langsung di kasir'
                                ? processCashPayment
                                : processPayment,
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
