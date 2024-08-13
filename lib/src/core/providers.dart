import 'package:ai_ecommerce/src/features/product/model/product.dart';
import 'package:dio/dio.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final options = BaseOptions(baseUrl: 'https://api.escuelajs.co/api/v1');
  return Dio(options);
}

@riverpod
GenerativeModel model(ModelRef ref) {
  final getProducts = FunctionDeclaration(
    'getProducts',
    'Get the list of all the products in stock either by the type (i.e Snack or Drink) or just everything.',
    Schema(SchemaType.object, properties: {
      'type': Schema(
        SchemaType.string,
        description: 'The type of products. Snack or Drink',
        nullable: true,
      ),
    }),
  );

  final searchProducts = FunctionDeclaration(
    'searchProducts',
    'Search the products that user want. This tools get products by filtering based on product name, one of the ingredient.',
    Schema(SchemaType.object, properties: {
      'title': Schema(
        SchemaType.string,
        description: 'The title of the products',
        nullable: true,
      ),
      'ingredient': Schema(
        SchemaType.string,
        description: 'One of the ingredient in the products',
        nullable: true,
      ),
      //'type': Schema(
      //  SchemaType.string,
      //  description: 'The type of products. Snacks or Drink',
      //  nullable: true,
      //),
    }),
  );

  return GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyCgkU-il5PeU32gd4p6B4YxDy1tWJkq99o',
    systemInstruction: Content.system(
        """You are a snack shop attendant and you are restricted to talk only about snacks and drink on the Menu. Do not talk about anything but ordering snack and drinks for the customer, ever.
Your goal is to provide what user want after understanding the menu items and any modifiers the customer wants.
Always verify and respond with drink and snack names from the provided product before adding them to the order.

      If i want to know every thing you have? Use your getProducts tool
      If am looking for a particaular snacks or drink, use the searchProducts tool.

      Example:
      User: Give me the list of snacks you have?
      Model: This are the snacks we have: ...
Don't make assumptions.
"""),
    tools: [
      Tool(functionDeclarations: [getProducts, searchProducts]),
    ],
  );
}
