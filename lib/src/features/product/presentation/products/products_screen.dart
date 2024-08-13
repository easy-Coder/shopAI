import 'package:ai_ecommerce/src/features/product/presentation/products/recommendation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ChatWithBot();
  }
}

class ChatWithBot extends ConsumerStatefulWidget {
  const ChatWithBot({
    super.key,
  });

  @override
  ConsumerState<ChatWithBot> createState() => _ChatWithBotState();
}

class _ChatWithBotState extends ConsumerState<ChatWithBot> {
  final queryController = TextEditingController();
  final scrollController = ScrollController();
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    Future(() {
      ref
          .read(recommendationControllerProvider.notifier)
          .sendMessage("Hello? Who are you? And how can you help me?");
    });

    ref.listenManual(recommendationControllerProvider, (prev, state) {
      if (state is AsyncData) {
        if (state.value == null) return;
        setState(() {
          messages.add(
            Message(
              message: state.value!,
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      messages.reversed.toList()[index].isUser
                          ? Text(
                              'User',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : const Text(
                              'AI ChatBot',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      4.verticalSpace,
                      Text(
                        messages.reversed.toList()[index].message,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (__, _) => 4.verticalSpace,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: queryController,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      minLines: 1,
                      maxLines: 2,
                      onSubmitted: (value) {
                        setState(() {
                          messages.add(
                            Message(message: value, isUser: true),
                          );
                        });
                        ref
                            .read(recommendationControllerProvider.notifier)
                            .sendMessage(value);
                        queryController.clear();
                      },
                      //textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "What do you have in mind",
                      ),
                    ),
                  ),
                  4.horizontalSpace,
                  ElevatedButton(
                    onPressed: () {
                      final value = queryController.text;
                      setState(() {
                        messages.add(
                          Message(message: value, isUser: true),
                        );
                      });
                      ref
                          .read(recommendationControllerProvider.notifier)
                          .sendMessage(value);
                      queryController.clear();
                    },
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Message {
  final String message;
  final bool isUser;

  const Message({
    required this.message,
    this.isUser = false,
  });
}
