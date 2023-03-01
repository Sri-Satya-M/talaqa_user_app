import 'package:flutter/material.dart';

import '../../../../../../model/session.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../widgets/avatar.dart';

class OtherBubble extends StatelessWidget {
  const OtherBubble({Key? key, required this.message, required this.session})
      : super(key: key);

  final String message;
  final Session session;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return FractionallySizedBox(
      widthFactor: 0.8,
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Avatar(
            url: session.clinician?.imageUrl,
            name: session.clinician?.user?.fullName,
            size: 30,
            borderRadius: BorderRadius.circular(15),
          ),
          Card(
            elevation: 0,
            color: MyColors.lightOrange,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message,
                      style: textTheme.subtitle2?.copyWith(
                        color: Colors.black,
                        fontSize: 18,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
