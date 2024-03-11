import 'package:flutter/material.dart';

import 'error_handling.dart';

class ErrorSnackBar {
  static show(context, e) {
    var textTheme = Theme.of(context).textTheme;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ErrorHandling.parseError(e),
          style: textTheme.titleSmall?.copyWith(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
      ),
    );
  }
}
