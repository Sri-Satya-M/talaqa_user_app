import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class SessionCard extends StatefulWidget {
  @override
  _SessionCardState createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
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
