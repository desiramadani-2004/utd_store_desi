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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF8BBD0), // Warna pink dasar
          primary: const Color(0xFFF48FB1),    // Pink yang sedikit lebih tegas
          surface: const Color(0xFFFFF1F5),    // Background pink sangat muda
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF48FB1),  // Warna bar atas
          foregroundColor: Colors.white,       // Warna tulisan di bar atas
        ),
      ),
      // Menerapkan GoRouter yang sudah dibuat
      routerConfig: AppRouter.router,
    );
  }
}