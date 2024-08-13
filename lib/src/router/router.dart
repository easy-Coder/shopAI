import 'package:ai_ecommerce/src/features/auth/presentation/login.dart';
import 'package:ai_ecommerce/src/features/product/presentation/product/product_screen.dart';
import 'package:ai_ecommerce/src/features/product/presentation/products/products_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

enum AppRouter {
  home,
  login,
  register,
  product,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: AppRouter.home.name,
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        name: AppRouter.product.name,
        path: '/product',
        builder: (context, state) => const ProductScreen(),
      ),
      GoRoute(
        name: AppRouter.login.name,
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
