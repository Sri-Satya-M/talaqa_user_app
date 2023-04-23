import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/strings.dart';

class SimplestDialog {
  static Future<bool?> show(
    BuildContext context,
    String message, {
    String? title,
  }) {
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(langBloc.getString(Strings.ok)),
            ),
          ],
        );
      },
    );
  }
}
