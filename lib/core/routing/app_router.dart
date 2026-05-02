import 'package:go_router/go_router.dart';
import '../../presentation/splash_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      // Rute katalog dan crypto akan ditambahkan di step selanjutnya
    ],
  );
}