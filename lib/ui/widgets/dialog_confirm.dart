import 'package:flutter/material.dart';

class ConfirmDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        var textTheme = Theme.of(context).textTheme;
        return AlertDialog(
          titlePadding: const EdgeInsets.all(16),
          title: title != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: textTheme.headline4!.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                  ],
                )
              : null,
          content: Text(
            message,
            style: textTheme.bodyText1!.copyWith(color: Colors.black),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('YES'),
            ),
          ],
        );
      },
    );
  }
}
