import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/di/injection.dart';
import '../data/isar_service.dart';
import '../domain/bookmark_item.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F5), 
      appBar: AppBar(
        title: const Text('Produk Favoritku'),
        backgroundColor: const Color(0xFFF48FB1),
        foregroundColor: Colors.white,
      ),
      // MENGGUNAKAN STREAM: Reaktif secara real-time tanpa setState
      body: StreamBuilder<List<BookmarkItem>>(
        stream: locator<IsarService>().listenToBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFF48FB1)));
          }
          
          final bookmarks = snapshot.data ?? [];
          
          if (bookmarks.isEmpty) {
            return const Center(child: Text('Belum ada produk favorit 💔'));
          }

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final item = bookmarks[index];
              
              // LOGIKA PERSONAL: Format waktu (Misal: "Disimpan pada 14:05")
              String formattedTime = '';
              if (item.savedAt != null) {
                formattedTime = DateFormat('HH:mm').format(item.savedAt!);
              }

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: item.image != null 
                    ? Image.network(item.image!, width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image),
                  title: Text(item.title ?? 'No Title', maxLines: 1, overflow: TextOverflow.ellipsis),
                  // Menampilkan teks waktu penyimpanan sesuai syarat
                  subtitle: Text(
                    'Disimpan pada $formattedTime', 
                    style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      // Karena IsarService kita pakai toggle, mengirim data dengan productId yang sama akan menghapusnya
                      final isar = await locator<IsarService>().db;
                      await isar.writeTxn(() async {
                         await isar.bookmarkItems.delete(item.id);
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}