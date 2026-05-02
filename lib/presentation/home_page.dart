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
      // Langsung perintahkan ambil data saat halaman dibuka
      create: (context) => locator<ProductCubit>()..fetchAllProducts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Katalog UTD Store Desi'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.teal));
            } else if (state is ProductError) {
              return Center(child: Text('Yah Error: ${state.message}'));
            } else if (state is ProductLoaded) {
              final products = state.products;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Image.network(
                        item.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      ),
                      title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      // LOGIKA PERSONAL: Teks khusus untuk NIM Genap
                      subtitle: Text('Harga: \$${item.price} (NIM Genap)', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
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