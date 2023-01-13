import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';

class ReferScreen extends StatefulWidget {
  @override
  _ReferScreenState createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Refer a friend"),
      ),
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
            const Text(
              "Refer to your friend and get \n a reward",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Share this link with your friends and after there install, both of you will get rewards.",
              textAlign: TextAlign.center,
              style: textTheme.caption,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: const BorderSide(width: 1, color: MyColors.lightGreen),
                fixedSize: const Size(110, 36),
              ),
              onPressed: null,
              child: Text("ALSN21", style: textTheme.headline4),
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
          child: const Text("Refer friend"),
        ),
      ),
    );
  }
}
