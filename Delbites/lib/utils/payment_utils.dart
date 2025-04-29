import 'package:uuid/uuid.dart';

class PaymentUtils {
  // Generate a unique order ID
  static String generateOrderId() {
    return 'ORDER-${const Uuid().v4().substring(0, 8)}-${DateTime.now().millisecondsSinceEpoch}';
  }

  // Format currency to Indonesian Rupiah
  static String formatToRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
  }

  // Parse Rupiah string to integer
  static int parseRupiah(String rupiahString) {
    return int.parse(rupiahString.replaceAll('Rp ', '').replaceAll('.', ''));
  }

  // Split full name into first and last name
  static Map<String, String> splitName(String fullName) {
    final parts = fullName.trim().split(' ');
    return {
      'firstName': parts[0],
      'lastName': parts.length > 1 ? parts.sublist(1).join(' ') : '',
    };
  }
}
