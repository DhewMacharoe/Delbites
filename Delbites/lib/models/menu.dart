class Menu {
  final int menuId;
  final int adminId;
  final String namaMenu;
  final String kategori;
  final double harga;
  final int stok;
  final String? gambar;

  Menu({
    required this.menuId,
    required this.adminId,
    required this.namaMenu,
    required this.kategori,
    required this.harga,
    required this.stok,
    this.gambar,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      menuId: json['menu_id'],
      adminId: json['admin_id'],
      namaMenu: json['nama_menu'],
      kategori: json['kategori'],
      harga: double.parse(json['harga'].toString()),
      stok: json['stok'],
      gambar: json['gambar'],
    );
  }
}
