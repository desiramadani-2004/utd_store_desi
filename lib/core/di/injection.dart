import 'package:get_it/get_it.dart';
import '../../data/api_service.dart';
import '../../presentation/cubit/product_cubit.dart';
import '../../data/isar_service.dart';
import '../../data/websocket_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Mendaftarkan alat pengambil data (hanya dibuat 1 kali)
  locator.registerLazySingleton<ApiService>(() => ApiService());

  // Mendaftarkan pengatur layar (Cubit)
  locator.registerFactory<ProductCubit>(() => ProductCubit(locator<ApiService>()));

  locator.registerLazySingleton<IsarService>(() => IsarService());

  // Bitcoin
  locator.registerLazySingleton<WebSocketService>(() => WebSocketService());
}