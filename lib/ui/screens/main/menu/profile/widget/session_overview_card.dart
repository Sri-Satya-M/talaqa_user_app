import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class SessionOverviewCard extends StatefulWidget {
  const SessionOverviewCard({super.key});

  @override
  _SessionOverviewCardState createState() => _SessionOverviewCardState();
}

class _SessionOverviewCardState extends State<SessionOverviewCard> {
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
                Text(
                  "03",
                  style: textTheme.headline5,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Pending Sessions",
              style: textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}
