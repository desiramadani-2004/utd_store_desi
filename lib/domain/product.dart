class Product {
  final int id;
  final String title;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  // Fungsi untuk mengubah data JSON dari API (Internet) menjadi Objek Dart
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      // Mengubah tipe data agar aman dari error koma (double)
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }
}