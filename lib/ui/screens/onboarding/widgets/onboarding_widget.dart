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
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black.withOpacity(0.85),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
