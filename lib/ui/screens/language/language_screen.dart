



















import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';

import '../../../config/routes.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String language="English";

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 100),
            Image.asset(Images.logo, height: 120),
            const SizedBox(height: 40),
            Text(
              "Choose",
              textAlign: TextAlign.center,
              style: textTheme.headline6,
            ),
            Text(
              "Your Language",
              textAlign: TextAlign.center,
              style: textTheme.headline4?.copyWith(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(18),
              height: 120,
              width: 390,
              decoration: const BoxDecoration(
                color: MyColors.paleGreen,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "English",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Radio(
                        value: "English",
                        groupValue: language,
                        onChanged: (value) {
                          setState(() {
                            language = value.toString();
                          });
                        },
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Hello",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CircleAvatar(
                          radius: 3,
                          backgroundColor: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      const Text(
                        "Hello",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              height: 120,
              width: 390,
              decoration: const BoxDecoration(
                color: MyColors.paleViolet,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Arabic",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Radio(
                        value: "Arabic",
                        groupValue: language,
                        onChanged: (value) {
                          setState(() {
                            language = value.toString();
                          });
                        },
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "أهلا",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CircleAvatar(
                          radius: 3,
                          backgroundColor: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      const Text(
                        "'ahlan",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: ProgressButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.onBoarding,
                  (route) => false,
            );
          },
          color: MyColors.primaryColor,
          child: const Text("Proceed"),
        ),
      ),
    );
  }
}
