import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bloc/language_bloc.dart';
import '../../../config/routes.dart';
import '../../../resources/strings.dart';

class LanguageScreen extends StatefulWidget {
  final bool isLoggingIn;

  const LanguageScreen({super.key, required this.isLoggingIn});

  static Future open({
    required BuildContext context,
    required bool isFromLogin,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LanguageScreen(
          isLoggingIn: isFromLogin,
        ),
      ),
    );
  }

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? language;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return WillPopScope(
      onWillPop: () => Future.value(!widget.isLoggingIn),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              Image.asset(Images.logo, height: 120),
              const SizedBox(height: 32),
              Text(
                langBloc.getString(Strings.choose),
                textAlign: TextAlign.center,
                style: textTheme.headline6,
              ),
              Text(
                langBloc.getString(Strings.yourLanguage),
                textAlign: TextAlign.center,
                style: textTheme.headline4?.copyWith(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  language = "English";
                  onTap.call(lang: "English");
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  height: 120,
                  width: 390,
                  decoration: const BoxDecoration(
                    color: MyColors.paleGreen,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
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
                            toggleable: true,
                            value: "English",
                            groupValue: language,
                            onChanged: (value) {
                              language = value.toString();
                              onTap.call(lang: language!);
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
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  language = "Arabic";
                  onTap.call(lang: "Arabic");
                },
                child: Container(
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
                            toggleable: true,
                            value: "Arabic",
                            groupValue: language,
                            onChanged: (value) {
                              setState(() {
                                language = value.toString();
                                onTap.call(lang: language!);
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
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTap({required String lang}) async {
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    ProgressUtils.handleProgress(
      context,
      task: () async {
        await langBloc.saveLanguage(
          language: lang.toLowerCase(),
          toApp: true,
        );
      },
      onSuccess: () {
        if (widget.isLoggingIn) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.onBoarding,
            (route) => false,
          );
        } else {
          Navigator.pop(context, true);
        }
      },
    );
  }
}
