import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/injection.dart';
import 'cubit/product_cubit.dart';
import 'cubit/product_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<ProductCubit>()..fetchAllProducts(),
      child: Scaffold(
        // Mengubah background halaman agar lebih soft pink
        backgroundColor: const Color(0xFFFFF1F5), 
        appBar: AppBar(
          title: const Text('Katalog UTD Store Desi'),
          backgroundColor: const Color(0xFFF48FB1), // Soft Pink
          foregroundColor: Colors.white, // Hilangkan const di sini
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              // Loadingnya juga pakai warna pink biar senada
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
                    // Warna card putih bersih
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
                          color: Color(0xFFF48FB1), // Harga jadi pink juga
                        )
                      ),
                      // Tambahan tombol Bookmark untuk persiapan Poin 3 (Database Isar)
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite_border, color: Color(0xFFF48FB1)),
                        onPressed: () {
                          // Nanti logika simpan ke Isar di sini
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