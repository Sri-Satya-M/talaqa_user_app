import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:alsan_app/bloc/session_bloc.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/main/main_screen.dart';
import 'package:alsan_app/ui/screens/profile/profile_email_screen.dart';
import 'package:alsan_app/ui/screens/profile/profile_mobile_screen.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../resources/strings.dart';
import '../screens/main/home/booking/widgets/review_time_slot_widget.dart';
import 'error_widget.dart';
import 'loading_widget.dart';

class SuccessScreen extends StatefulWidget {
  final String type;
  final String? message;
  final String? subtitle;
  final String? sessionId;

  const SuccessScreen({
    super.key,
    required this.type,
    this.subtitle,
    required this.message,
    this.sessionId,
  });

  static Future open(
    BuildContext context, {
    required String type,
    String? subtitle,
    required String message,
    String? sessionId,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SuccessScreen(
          type: type,
          message: message,
          subtitle: subtitle,
          sessionId: sessionId,
        ),
      ),
    );
  }

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 16 / 11,
                child: Lottie.asset(Images.success, fit: BoxFit.fitWidth),
              ),
              const SizedBox(height: 32),
              if (widget.sessionId != null) ...[
                FutureBuilder(
                  future: sessionBloc.getSessionById(widget.sessionId!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return CustomErrorWidget(error: snapshot.error);
                    }
                    if (!snapshot.hasData) return const LoadingWidget();
                    var session = snapshot.data;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5BFF9F),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text('${session!.sessionId}'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              langBloc.getString(Strings.speechTherapy),
                              style: textTheme.headlineMedium,
                            ),
                            getModeOfConsultation(
                              mode: session.consultationMode!,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ReviewTimeSlotWidget(
                          dateTime: session.date!,
                          timeslots: session.sessionTimeslots!
                              .map((e) => e.timeslot!)
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ],
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Text(
                      widget.message ?? '',
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.subtitle ?? '',
                      textAlign: TextAlign.center,
                      style: textTheme.titleSmall?.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 32,
        ),
        child: ProgressButton(
          onPressed: () {
            if (widget.type == 'PAYMENT' || widget.type == 'FEEDBACK') {
              var mainBloc = Provider.of<MainBloc>(context, listen: false);
              mainBloc.changeIndex(0);
            }

            switch (widget.type) {
              case 'MOBILE':
                ProfileMobileScreen.open(context);
                break;
              case 'EMAIL':
                ProfileEmailScreen.open(context);
                break;
              case 'MAIN':
                MainScreen.open(context);
                break;
              case 'Payment':
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
                break;
              default:
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
            }
          },
          child: Text(langBloc.getString(Strings.continueee)),
        ),
      ),
    );
  }

  Widget getModeOfConsultation({required String mode}) {
    String icon = '';
    String modeText = '';
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    switch (mode) {
      case 'AUDIO':
        icon = Images.callMode;
        modeText = langBloc.getString(Strings.audio);
        break;
      case 'VIDEO':
        icon = Images.videoMode;
        modeText = langBloc.getString(Strings.video);
        break;
      case 'HOME':
        icon = Images.homeMode;
        modeText = langBloc.getString(Strings.atHome);
        break;
    }
    return Row(
      children: [
        Image.asset(
          icon,
          height: 16,
        ),
        const SizedBox(width: 8),
        Text(
          modeText,
          style: textTheme.bodyLarge
              ?.copyWith(color: Colors.lightBlue, fontSize: 16),
        ),
      ],
    );
  }
}
