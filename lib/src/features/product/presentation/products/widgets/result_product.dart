import 'package:ai_ecommerce/src/features/product/model/product.dart';
import 'package:ai_ecommerce/src/features/product/presentation/products/recommendation_controller.dart';
import 'package:ai_ecommerce/src/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResultProduct extends ConsumerWidget {
  const ResultProduct({required this.products, super.key});

  final List<Product> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            ref.invalidate(recommendationControllerProvider);
          },
        ),
        title: const Text('R E S U L T', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile_pic.png'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: ListView.separated(
        itemCount: products.length,
        itemBuilder: (context, index) => FoodItemCard(
          name: products[index].name,
          description: products[index].description,
          price: products[index].price,
          rating: products[index].rating['rating'],
          imageUrl: '',
        ),
        separatorBuilder: (context, index) => 16.verticalSpace,
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final double rating;
  final String imageUrl;

  const FoodItemCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRouter.product.name),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(description),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$$price',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Text('$rating (25+)'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
