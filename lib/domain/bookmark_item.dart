import 'package:isar/isar.dart';

part 'bookmark_item.g.dart'; // Baris ini awalnya akan MERAH, biarkan saja!

@collection
class BookmarkItem {
  // Id ini wajib untuk Isar (Auto Increment)
  Id id = Isar.autoIncrement;

  // Menyimpan ID asli produk dari API
  int? productId;

  String? title;
  
  double? price;
  
  String? image;

  // LOGIKA PERSONAL (Poin 3): Wajib menyimpan waktu saat tombol ditekan
  DateTime? savedAt; 
}