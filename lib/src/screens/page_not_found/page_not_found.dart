import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Page not found"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text("Go to home page"),
        ),
      ),
    );
  }
}