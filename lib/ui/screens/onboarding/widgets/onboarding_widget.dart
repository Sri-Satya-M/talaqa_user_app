import 'package:flutter/material.dart';

class OnBoardingWidget extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnBoardingWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 8,
          child: Image.asset(image, fit: BoxFit.fitWidth),
        ),
        const SizedBox(height: 16),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  title,
                  style: textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyText2?.copyWith(
                    color: Colors.black.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
