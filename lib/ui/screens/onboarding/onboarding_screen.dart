import 'package:alsan_app/ui/screens/onboarding/widgets/how_to_use.dart';
import 'package:flutter/material.dart';

import '../../../config/routes.dart';
import '../../../resources/colors.dart';
import '../../../resources/images.dart';
import '../../widgets/progress_button.dart';
import 'widgets/onboarding_widget.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  static Future open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OnBoardingScreen(),
      ),
    );
  }

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              currentIndex = value;
              setState(() {});
            },
            children: [
              const OnBoardingWidget(
                image: Images.onBoardingImage1,
                title: 'Book Speech Therapy Sessions Online',
                description:
                    'Users can search and book online/offline sessions with speech therapy consultants right from their fingertips.',
              ),
              const OnBoardingWidget(
                image: Images.onBoardingImage2,
                title: 'Book Speech Therapy Sessions Online',
                description:
                    'Users can search and book online/offline sessions with speech therapy consultants right from their fingertips.',
              ),
              const OnBoardingWidget(
                image: Images.onBoardingImage3,
                title: 'Book Speech Therapy Sessions Online',
                description:
                    'Users can search and book online/offline sessions with speech therapy consultants right from their fingertips.',
              ),
              HowToUse()
            ],
          ),
          Positioned(
            left: 35,
            right: 35,
            bottom: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    for (int i = 0; i < 4; i++) ...[
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: (currentIndex == i)
                            ? MyColors.secondaryColor
                            : MyColors.secondaryColor.withOpacity(0.3),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ],
                ),
                const Spacer(),
                (currentIndex < 3)
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(55, 55),
                          maximumSize: const Size(55, 55),
                          alignment: Alignment.center,
                        ),
                        onPressed: () {
                          pageController.animateToPage(
                            currentIndex + 1,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                        child: const Icon(Icons.arrow_forward_ios_outlined),
                      )
                    : ProgressButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.mobile,
                            (_) => false,
                          );
                        },
                        child: const Text('Get Started'),
                      ),
              ],
            ),
          ),
          if (currentIndex < 3)
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.mobile,
                    (_) => false,
                  );
                },
                child: Text(
                  'Skip',
                  style: textTheme.bodyText2?.copyWith(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
