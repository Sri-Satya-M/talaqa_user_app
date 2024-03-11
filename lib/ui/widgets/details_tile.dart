import 'package:flutter/material.dart';

class DetailsTile extends StatelessWidget {
  final Widget? title;
  final Widget? value;
  final double? gap;
  final EdgeInsets padding;

  const DetailsTile({
    Key? key,
    this.title,
    this.value,
    this.gap,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DefaultTextStyle(
            style: textTheme.bodyMedium!,
            child: title!,
          ),
          SizedBox(height: gap ?? 4),
          DefaultTextStyle(
            style: textTheme.bodyLarge!,
            child: value!,
          ),
        ],
      ),
    );
  }
}
