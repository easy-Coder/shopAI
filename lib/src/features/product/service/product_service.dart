import 'package:ai_ecommerce/src/core/providers.dart';
import 'package:ai_ecommerce/src/features/product/data/product_repository.dart';
import 'package:ai_ecommerce/src/features/product/model/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_service.g.dart';

class ProductService {
  late final Ref _ref;
  late ChatSession chat;

  ProductService(Ref ref) {
    _ref = ref;
    chat = _ref.read(modelProvider).startChat();
  }

  Future<String?> getRecommendation(String query) async {
    var response = await chat.sendMessage(
      Content.text(query),
    );
    final functionCalls = response.functionCalls.toList();
    functionCalls.forEach((e) => print(e.toJson()));

    if (functionCalls.isNotEmpty) {
      print('----------------------------------------------------------');
      final result = switch (functionCalls.first.name) {
        // Forward arguments to the hypothetical API.
        'searchProducts' =>
          await _ref.read(productRepositoryProvider).searchProduct(
                name: functionCalls.first.args['name'] as String?,
                ingredient: functionCalls.first.args['ingredients'] as String?,
                //type: functionCalls.first.args['type'] as String?,
              ),
        'getProducts' => await _ref.read(productRepositoryProvider).getProducts(
              type: functionCalls.first.args['type'] as String?,
            ),
        // Throw an exception if the model attempted to call a function that was
        // not declared.
        _ => throw UnimplementedError(
            'Function not implemented: ${functionCalls.first.name}')
      };
      print(result);
      response = await chat
          .sendMessage(Content.functionResponse(functionCalls.first.name, {
        'products': result,
      }));
    }

    response.candidates.forEach((e) => print(e.text));
    return response.text;
  }
}

@riverpod
ProductService productService(ProductServiceRef ref) {
  return ProductService(ref);
}
