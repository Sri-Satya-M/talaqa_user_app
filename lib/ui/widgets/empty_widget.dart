import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/strings.dart';

class EmptyWidget extends StatelessWidget {
  final String? image;
  final String? message;
  final String? subtitle;
  final double size;
  final Color? fontColor;

  const EmptyWidget({
    Key? key,
    this.image,
    this.message,
    this.size = 120,
    this.subtitle,
    this.fontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.asset(
            //   image ?? Images.logo,
            //   height: size,
            //   width: size,
            // ),
            // const SizedBox(height: 20),
            Text(
              message ?? langBloc.getString(Strings.nothingShowHere),
              style: textTheme.headlineSmall!.copyWith(
                color: fontColor,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (subtitle != null)
              Text(
                '$subtitle',
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
              )
          ],
        ),
      ),
    );
  }
}
