import 'package:flutter/material.dart';

class ConfirmDialog {
  static Future<bool?> show(
    BuildContext context,
    String message, {
    String? title,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        var textTheme = Theme.of(context).textTheme;
        return AlertDialog(
          titlePadding: EdgeInsets.all(16),
          title: title != null
              ? Text(
                  title,
                  style: textTheme.headline6!.copyWith(color: Colors.black),
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('YES'),
            ),
          ],
        );
      },
    );
  }
}
