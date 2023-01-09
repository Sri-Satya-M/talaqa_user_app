import 'package:flutter/material.dart';
import '../../resources/colors.dart';

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
          title: title != null
              ? Text(
                  title,
                  style: textTheme.bodyText1!.copyWith(color: Colors.white),
                )
              : null,
          content: Text(
            message,
            style: textTheme.headline6!.copyWith(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: MyColors.background,
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
