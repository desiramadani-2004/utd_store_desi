import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/api_service.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ApiService apiService;

  ProductCubit(this.apiService) : super(ProductInitial());

  void fetchAllProducts() async {
    emit(ProductLoading()); // Ubah layar jadi muter-muter (Loading)
    try {
      final products = await apiService.fetchProducts();
      emit(ProductLoaded(products)); // Tampilkan data jika sukses
    } catch (e) {
      emit(ProductError(e.toString())); // Tampilkan error jika gagal
    }
  }
}