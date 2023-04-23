import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/strings.dart';

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
        var langBloc = Provider.of<LangBloc>(context, listen: false);
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
              child: Text(langBloc.getString(Strings.no)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(langBloc.getString(Strings.yes)),
            ),
          ],
        );
      },
    );
  }
}
