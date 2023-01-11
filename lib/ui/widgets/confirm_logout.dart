import 'package:flutter/material.dart';

class ConfirmLogout {
  static Future<bool?> open(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 25,
          ),
          elevation: 5,
          content: Text(
            'Are you sure you want to logout ?',
            style: textTheme.headline5,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
