import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class SessionOverviewCard extends StatelessWidget {
  final String icon;
  final String title;
  final String count;

  const SessionOverviewCard({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return CustomCard(
      height: 120,
      width: 150,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(Images.pendingSession),
                Text(count, style: textTheme.headline5),
              ],
            ),
            const SizedBox(height: 20),
            Text(title, style: textTheme.caption),
          ],
        ),
      ),
    );
  }
}
