import 'dart:convert';

import 'package:ai_ecommerce/src/core/providers.dart';
import 'package:ai_ecommerce/src/features/product/model/product.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_repository.g.dart';

class ProductRepository {
  ProductRepository() {
    loadProducts();
  }

  List<Map<String, dynamic>> _products = [];

  // Function to load the JSON file
  Future<void> loadProducts() async {
    try {
      String jsonString = await rootBundle.loadString('assets/products.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      _products = List<Map<String, dynamic>>.from(jsonData['products']);
      print(_products[0]);
    } catch (e) {
      print('Error loading products: $e');
      throw Exception('Error loading products');
    }
  }

  // Function to search for products
  Future<List<Map<String, dynamic>>> searchProduct({
    String? name,
    double? maxPrice,
    String? ingredient,
  }) async {
    await loadProducts();
    return _products.where((product) {
      print(product);
      bool nameMatch = name == null ||
          product['name'].toLowerCase().contains(name.toLowerCase());
      bool priceMatch = maxPrice == null || product['price'] <= maxPrice;
      bool ingredientMatch =
          ingredient == null || product['ingredients'].contains(ingredient);

      return nameMatch && priceMatch && ingredientMatch;
    }).toList();
  }

  // Function to get products by type
  Future<List<Map<String, dynamic>>> getProducts({String? type}) async {
    await loadProducts();
    if (type == null) {
      return _products;
    }
    print(_products);
    return _products
        .where(
          (product) => product['type'].toString().contains(
                type.toLowerCase(),
              ),
        )
        .toList();
  }
}

@Riverpod(keepAlive: true)
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepository();
}
