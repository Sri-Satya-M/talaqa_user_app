import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:flutter/material.dart';

import '../../../../../../model/session.dart';
import '../../../../../../resources/colors.dart';

class SelfBubble extends StatelessWidget {
  const SelfBubble({Key? key, required this.message, required this.session})
      : super(key: key);

  final String message;
  final Session session;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return FractionallySizedBox(
      widthFactor: 0.8,
      alignment: Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Card(
            elevation: 3,
            color: MyColors.primaryColor,
            margin: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 8,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    message,
                    style: textTheme.subtitle2?.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Avatar(
            url: session.patientProfile?.image,
            name: session.patientProfile?.user?.fullName,
            size: 30,
            borderRadius: BorderRadius.circular(15),
          ),
        ],
      ),
    );
  }
}
