import 'package:Delbites/waiting_page.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> pesanan;

  const CheckoutPage({Key? key, required this.pesanan}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? selectedPayment;

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
          backgroundColor: Colors.blue[900],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _showCancelDialog(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pembayaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _paymentOption('Bayar langsung di kasir', Icons.store),
                    _paymentOption(
                        'Transfer ke Mandiri', Icons.account_balance),
                    _paymentOption('Transfer ke Dana', Icons.payment),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pesanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          'Rp ${widget.pesanan[index]['price']} x ${widget.pesanan[index]['quantity']}',
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Rp ${getTotalHarga()}',
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
                      : () {
                          if (selectedPayment == "Bayar langsung di kasir") {
                            List<Map<String, String>> ordersToSend =
                                widget.pesanan.map((item) {
                              return {
                                "name": item["name"].toString(),
                                "price": item["price"].toString(),
                                "quantity": item["quantity"].toString(),
                                "date": "Sekarang",
                                "status": "Pending",
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
                                builder: (context) =>
                                    WaitingPage(orders: ordersToSend),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPayment == null
                        ? Colors.grey
                        : Colors.blue[900],
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
              color: selectedPayment == title ? Colors.blue[900]! : Colors.grey,
              width: selectedPayment == title ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.blue[900]),
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
