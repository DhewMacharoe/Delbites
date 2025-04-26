import 'dart:convert';

import 'package:Delbites/home.dart';
import 'package:Delbites/keranjang.dart';
import 'package:Delbites/waiting_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RiwayatPesananPage extends StatefulWidget {
  final List<Map<String, String>>? newOrders;

  const RiwayatPesananPage({Key? key, this.newOrders}) : super(key: key);

  @override
  _HistoryPesananPageState createState() => _HistoryPesananPageState();
}

class _HistoryPesananPageState extends State<RiwayatPesananPage> {
  String selectedStatus = "Menunggu";
  List<Map<String, String>> orders = [];

  final Map<String, Color> statusColors = {
    "Menunggu": Color(0xFFFFC107),
    "Diproses": Color(0xFF2196F3),
    "Selesai": Color(0xFF4CAF50),
    "Dibatalkan": Color(0xFFF44336),
  };

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/pemesanan';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print(response.body);

        List<dynamic> data = json.decode(response.body);

        setState(() {
          orders = data.map((order) {
            return {
              'name': order['pelanggan']['name']?.toString() ?? '',
              'quantity': order['quantity']?.toString() ?? '',
              'payment': order['metode_pembayaran']?.toString() ?? '',
              'date': order['waktu_pemesanan']?.toString() ?? '',
              'price': order['total_harga']?.toString() ?? '',
              'status': order['status']?.toString() ?? '',
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStatusTabs(),
          Expanded(child: _buildOrderList()),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF4C53A5),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Riwayat Pemesanan',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatusTabs() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: statusColors.keys
              .map((status) => _buildStatusButton(status))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildStatusButton(String status) {
    bool isSelected = selectedStatus == status;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = status;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? statusColors[status]! : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: statusColors[status]!),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : statusColors[status]!,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    List<Map<String, String>> filteredOrders =
        orders.where((order) => order["status"] == selectedStatus).toList();

    return filteredOrders.isEmpty
        ? const Center(
            child: Text(
              "Tidak ada pesanan di status ini",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              var order = filteredOrders[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  title: Text(order["name"].toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Jumlah: ${order["quantity"].toString()}"),
                      Text("Metode Bayar: ${order["payment"].toString()}"),
                      Text("Tanggal: ${order["date"].toString()}"),
                    ],
                  ),
                  trailing: Text("Rp${order["price"] ?? "0"}"),
                  onTap: () {
                    if (selectedStatus == "menunggu") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaitingPage(orders: [order]),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
  }

  Widget _buildBottomNavigationBar() {
    return CurvedNavigationBar(
      backgroundColor: Colors.white,
      color: const Color(0xFF2D5EA2),
      buttonBackgroundColor: const Color(0xFF2D5EA2),
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      items: const <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.history, size: 30, color: Colors.white),
        Icon(Icons.shopping_cart, size: 30, color: Colors.white),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RiwayatPesananPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KeranjangPage()),
          );
        }
      },
    );
  }
}
