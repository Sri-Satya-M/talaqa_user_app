import 'package:flutter/material.dart';

class ReverseDetailsTile extends StatelessWidget {
  final Widget title;
  final Widget value;
  final double? gap;

  const ReverseDetailsTile({
    Key? key,
    required this.title,
    required this.value,
    this.gap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DefaultTextStyle(
          style: textTheme.bodySmall!,
          child: title,
        ),
        SizedBox(height: gap ?? 4),
        DefaultTextStyle(
          style: textTheme.headlineSmall!,
          child: value,
        ),
      ],
    );
  }
}
