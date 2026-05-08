import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // WAJIB DITAMBAHKAN untuk MethodChannel
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; 
import '../core/di/injection.dart';
import '../../data/isar_service.dart'; 
import 'cubit/product_cubit.dart';
import 'cubit/product_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // 1. Deklarasi MethodChannel (Sesuai dengan nama di Kotlin)
  static const platform = MethodChannel('com.desi.utd_store/native');

  // 2. Fungsi memanggil Native Toast (POIN 5)
  Future<void> _showNativeToast() async {
    try {
      await platform.invokeMethod('showToast', {"message": "Halo dari Native Android! - Desi"});
    } on PlatformException catch (e) {
      debugPrint("Gagal memanggil toast: '${e.message}'.");
    }
  }

  // 3. Fungsi memanggil Persentase Baterai (POIN 5)
  Future<void> _getBattery(BuildContext context) async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      // Menampilkan baterai di layar menggunakan SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sisa Baterai HP: $result% 🔋', style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: const Color(0xFFF48FB1),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } on PlatformException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal cek baterai: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<ProductCubit>()..fetchAllProducts(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF1F5), 
        appBar: AppBar(
          title: const Text('Katalog UTD Store Desi', style: TextStyle(fontSize: 18)),
          backgroundColor: const Color(0xFFF48FB1), 
          foregroundColor: Colors.white,
          actions: [
            // TOMBOL TOAST NATIVE
            IconButton(
              icon: const Icon(Icons.message),
              tooltip: 'Test Native Toast',
              onPressed: _showNativeToast,
            ),
            // TOMBOL CEK BATERAI NATIVE
            IconButton(
              icon: const Icon(Icons.battery_charging_full),
              tooltip: 'Cek Baterai',
              onPressed: () => _getBattery(context),
            ),
            // TOMBOL CRYPTO
            IconButton(
              icon: const Icon(Icons.currency_bitcoin),
              tooltip: 'Live Crypto',
              onPressed: () {
                context.push('/crypto'); 
              },
            ),
            // TOMBOL BOOKMARK
            IconButton(
              icon: const Icon(Icons.bookmarks),
              tooltip: 'Favorit',
              onPressed: () {
                context.push('/bookmarks'); 
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFFF48FB1)));
            } else if (state is ProductError) {
              return Center(child: Text('Yah Error: ${state.message}'));
            } else if (state is ProductLoaded) {
              final products = state.products;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                        ),
                      ),
                      title: Text(
                        item.title, 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Harga: \$${item.price}', 
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFFF48FB1), 
                        )
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite_border, color: Color(0xFFF48FB1)),
                        onPressed: () async {
                          await locator<IsarService>().toggleBookmark(item);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Status Favorit diperbarui! 🌸'),
                                backgroundColor: Color(0xFFF48FB1),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}