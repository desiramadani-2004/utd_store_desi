import 'package:go_router/go_router.dart';
import '../../presentation/splash_page.dart';
import '../../presentation/home_page.dart';
import '../../presentation/bookmark_page.dart'; // <-- JANGAN LUPA IMPORT INI

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      // --- RUTE BARU UNTUK HALAMAN FAVORIT (POIN 3) ---
      GoRoute(
        path: '/bookmarks',
        builder: (context, state) => const BookmarkPage(),
      ),
      // Rute crypto dan detail akan ditambahkan di step selanjutnya
    ],
  );
}