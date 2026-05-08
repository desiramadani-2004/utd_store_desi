import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; 
import '../core/di/injection.dart';
import '../../data/isar_service.dart'; 
import 'cubit/product_cubit.dart';
import 'cubit/product_state.dart';

// Import halaman profil yang baru dibuat
import 'profile_page.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const platform = MethodChannel('com.desi.utd_store/native');

  //baterai
  Future<void> _getBattery(BuildContext context) async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      if (context.mounted) {
        _showStyledSnackBar(context, 'Sisa Baterai HP: $result% 🔋');
      }
    } on PlatformException catch (e) {
      if (context.mounted) _showStyledSnackBar(context, 'Gagal: ${e.message}');
    }
  }

  // Fungsi helper buat SnackBar
  void _showStyledSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF48FB1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.only(bottom: 30, left: 50, right: 50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<ProductCubit>()..fetchAllProducts(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF1F5), 
        appBar: AppBar(
          backgroundColor: const Color(0xFFF48FB1), 
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('UTD Store', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text('Desi', style: TextStyle(fontSize: 14, color: Colors.white70)),
            ],
          ),
          actions: [
            // TOMBOL PROFIL YANG SUDAH DIHUBUNGKAN
            IconButton(
              icon: const Icon(Icons.account_circle, size: 28), 
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              }
            ),
            IconButton(icon: const Icon(Icons.battery_charging_full), onPressed: () => _getBattery(context)),
            IconButton(icon: const Icon(Icons.currency_bitcoin), onPressed: () => context.push('/crypto')),
            IconButton(icon: const Icon(Icons.bookmarks), onPressed: () => context.push('/bookmarks')),
          ],
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFFF48FB1)));
            if (state is ProductLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  childAspectRatio: 0.7, 
                  crossAxisSpacing: 12, 
                  mainAxisSpacing: 12,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final item = state.products[index];
                  // GESTURE DETECTOR UNTUK POP UP SUDAH DIHAPUS
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Center(child: Image.network(item.image, fit: BoxFit.contain)),
                              ),
                              Positioned(
                                top: 5, right: 5,
                                child: IconButton(
                                  icon: const Icon(Icons.bookmark_border, color: Color(0xFFF48FB1)),
                                  onPressed: () async {
                                    await locator<IsarService>().toggleBookmark(item);
                                    if (context.mounted) _showStyledSnackBar(context, 'Bookmark diperbarui! 🌸');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(height: 5),
                              Text('\$${item.price}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF48FB1))),
                            ],
                          ),
                        ),
                      ],
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