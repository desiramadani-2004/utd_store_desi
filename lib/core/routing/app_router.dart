import 'package:go_router/go_router.dart';
import '../../presentation/splash_page.dart';
import '../../presentation/home_page.dart';

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
      // Rute crypto dan detail akan ditambahkan di step selanjutnya
    ],
  );
}