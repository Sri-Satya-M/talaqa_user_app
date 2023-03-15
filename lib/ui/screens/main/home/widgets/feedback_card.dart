import 'package:alsan_app/model/feedback.dart' as f;
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';

import '../../../../../resources/colors.dart';
import '../../../../widgets/avatar.dart';
import '../../../../widgets/custom_card.dart';
import '../../../../widgets/details_tile.dart';

class FeedbackCard extends StatelessWidget {
  final f.Feedback feedback;

  const FeedbackCard({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var moment = Moment.now().from(feedback.createdAt!);
    return CustomCard(
      radius: 4,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(
                  url: feedback.patient?.image,
                  name: feedback.patient!.user!.fullName!,
                  borderRadius: BorderRadius.circular(20),
                  size: 40,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DetailsTile(
                      title: Text(
                        feedback.patient!.user!.fullName!,
                        style: textTheme.bodyText2,
                      ),
                      value: Text(moment, style: textTheme.caption),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: MyColors.primaryColor.withOpacity(0.2),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: MyColors.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        feedback.rating.toString(),
                        style: textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${feedback.comment}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
