import 'package:ai_ecommerce/src/features/product/model/product.dart';
import 'package:ai_ecommerce/src/features/product/service/product_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommendation_controller.g.dart';

@riverpod
class RecommendationController extends _$RecommendationController {
  // 3. override the [build] method to return a [FutureOr]
  @override
  Future<String?> build() {
    return Future.value(null);
  }

  Future<void> sendMessage(String query) async {
    // 5. read the repository using ref
    final productService = ref.read(productServiceProvider);
    // 6. set the loading state
    state = const AsyncLoading();
    // 7. sign in and update the state (data or error)
    state =
        await AsyncValue.guard(() => productService.getRecommendation(query));
  }
}
