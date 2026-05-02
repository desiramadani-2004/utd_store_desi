import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'core/di/injection.dart';

void main() {
  // WAJIB: Panggil Dependency Injection sebelum aplikasi berjalan
  setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'UTD Store Desi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // Menerapkan GoRouter yang sudah dibuat
      routerConfig: AppRouter.router,
    );
  }
}