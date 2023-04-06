import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

enum ToastrType {
  success,
  error,
}

class AppRepository {
  AppRepository._() : super();
  static final AppRepository _instance = AppRepository._();
  factory AppRepository() {
    return _instance;
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  navigate(String path) {
    GoRouter.of(navigatorKey.currentContext!).go(path);
  }

  showToastr({
    required String message,
    ToastrType type = ToastrType.error,
  }) {
    Color bgColor;
    switch (type) {
      case ToastrType.error:
        bgColor = Colors.red;
        break;
      case ToastrType.success:
        bgColor = Colors.green;
    }
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
      ),
    );
  }

  showConfirmDialog({
    String title = 'Are you sure?',
    Widget? content,
    String? message,
    bool isCancelable = true,
    required void Function() onSubmit,
    void Function()? onCancel,
  }) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: message != null ? Text(message) : content,
          actions: [
            if (isCancelable)
              TextButton(
                child: const Text('Cancel'),
                onPressed:  () {
                  context.pop();
                  if (onCancel != null) {
                    onCancel();
                  }
                },
              ),
            
            TextButton(
              child: const Text('Confirm'),
              onPressed:  () {
                context.pop();
                onSubmit();
              },
            ),
          ],
        );
      },
    );
  }
}