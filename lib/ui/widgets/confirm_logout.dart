import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/strings.dart';

class ConfirmLogout {
  static Future<bool?> open(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
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
            '${langBloc.getString(Strings.areYouSureYouWantToLogout)} ?',
            style: textTheme.headline5,
          ),
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
