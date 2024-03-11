import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../resources/strings.dart';

class ReferScreen extends StatefulWidget {
  const ReferScreen({super.key});

  @override
  _ReferScreenState createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.referAFriend))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 82),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Images.referImage,
              height: 162,
              width: 182,
            ),
            const SizedBox(height: 12),
            Text(
              langBloc.getString(Strings.referToYourFriendAndGetAReward),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              langBloc.getString(Strings
                  .shareThisLinkWithYourFriendsAndAfterTheyInstallBothOfYouWillGetRewards),
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: const BorderSide(width: 1, color: MyColors.lightGreen),
                fixedSize: const Size(110, 36),
              ),
              onPressed: null,
              child: Text("ALSN21", style: textTheme.headlineMedium),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 32,
        ),
        child: ProgressButton(
          onPressed: () {},
          child: Text(langBloc.getString(Strings.referFriend)),
        ),
      ),
    );
  }
}
