import 'package:flutter/material.dart';

import '../../../../../../resources/colors.dart';

class DetailsBox extends StatelessWidget {
  final String title;
  final Widget child;

  const DetailsBox({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: MyColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Text(
              title,
              style: textTheme.caption?.copyWith(color: Colors.black),
            ),
          ),
          const Divider(),
          child,
        ],
      ),
    );
  }
}
