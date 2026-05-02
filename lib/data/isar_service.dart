import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/bookmark_item.dart';
import '../domain/product.dart'; // Pastikan import Product kamu sesuai

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  // Membuka koneksi ke Database Isar
  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [BookmarkItemSchema], // Ini didapat dari file .g.dart yang baru saja di-generate
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // Fungsi untuk menyimpan / menghapus Bookmark
  Future<void> toggleBookmark(Product product) async {
    final isar = await db;
    
    // Cek apakah produk ini sudah pernah difavoritkan sebelumnya
    final existingBookmark = await isar.bookmarkItems.filter().productIdEqualTo(product.id).findFirst();

    await isar.writeTxn(() async {
      if (existingBookmark != null) {
        // Jika sudah ada, hapus dari favorit
        await isar.bookmarkItems.delete(existingBookmark.id);
      } else {
        // Jika belum ada, simpan! 
        // LOGIKA PERSONAL (Poin 3): Wajib simpan waktu saat tombol ditekan
        final newItem = BookmarkItem()
          ..productId = product.id
          ..title = product.title
          ..price = product.price.toDouble()
          ..image = product.image
          ..savedAt = DateTime.now(); // <-- Ini menyimpan Timestamp!
          
        await isar.bookmarkItems.put(newItem);
      }
    });
  }

  // Fungsi Stream Reactive: Agar UI langsung update tanpa setState()
  Stream<List<BookmarkItem>> listenToBookmarks() async* {
    final isar = await db;
    // watch() akan bereaksi secara real-time setiap ada perubahan data
    yield* isar.bookmarkItems.where().watch(fireImmediately: true);
  }
}