import 'package:go_router/go_router.dart';
import '../../presentation/splash_page.dart';
import '../../presentation/home_page.dart';
import '../../presentation/bookmark_page.dart'; // <-- JANGAN LUPA IMPORT INI
import '../../presentation/crypto_page.dart';

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
    
      GoRoute(
        path: '/bookmarks',
        builder: (context, state) => const BookmarkPage(),
      ),
      
      GoRoute(
        path: '/crypto',
        builder: (context, state) => const CryptoPage(),
      ),
    ],
  );
}