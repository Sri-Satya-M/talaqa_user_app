import 'dart:async';

import 'package:alsan_app/model/session.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/images.dart';
import '../../../../../utils/helper.dart';

class SessionAtHomeScreen extends StatefulWidget {
  final Session session;
  final Duration duration;

  const SessionAtHomeScreen({
    super.key,
    required this.session,
    required this.duration,
  });

  static Future open(
    BuildContext context, {
    required Session session,
    required Duration duration,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SessionAtHomeScreen(
          session: session,
          duration: duration,
        ),
      ),
    );
  }

  @override
  _SessionAtHomeScreenState createState() => _SessionAtHomeScreenState();
}

class _SessionAtHomeScreenState extends State<SessionAtHomeScreen> {
  bool isRunning = false;
  Timer? _timer;
  bool extendTime = false;
  late Duration duration;
  late Duration currentTimeDiff;
  final Duration oneSecond = const Duration(seconds: 1);
  late Session session;
  late int totalTime;
  double indicator = 0;

  @override
  void initState() {
    session = widget.session;
    duration = widget.duration;
    totalTime = widget.session.clinicianTimeSlots!.length * 60;
    super.initState();
    if (duration.inMinutes > 0) {
      isRunning = true;
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('At Home')),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: MyColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Speech Therapy',
                          style: textTheme.bodyText2?.copyWith(fontSize: 12),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5BFF9F),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text('${session.sessionId}'),
                        ),
                      ],
                    ),
                    DetailsTile(
                      title: Text(session.clinician!.user!.fullName!),
                      value: Text(
                        session.clinician?.designation ?? 'NA',
                        style: textTheme.caption?.copyWith(
                          color: MyColors.cerulean,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isRunning) ...[
                      Row(
                        children: [
                          Text(
                            'Your Session Has been Started',
                            style: textTheme.caption?.copyWith(fontSize: 14),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${(duration.inHours % 60).toString().padLeft(2, '0')}:'
                            '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
                            '${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: textTheme.bodyText1?.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: calculateTimeCompleted(),
                      backgroundColor: MyColors.divider,
                      color: MyColors.primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              otpBloc(),
            ],
          ),
        ),
      ),
    );
  }

  calculateTimeCompleted() {
    if (extendTime) {
      totalTime += 30 * 60;
    }

    return (totalTime - duration.inMinutes) / totalTime;
  }

  Widget otpBloc() {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: MyColors.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Text('Your OTP'),
              const Spacer(),
              for (int i = 0; i < session.otp.toString().length; i++) ...[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: MyColors.cerulean),
                  ),
                  child: Text(
                    session.otp.toString()[i],
                    style: textTheme.bodyText1?.copyWith(
                      color: MyColors.cerulean,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Images.calender),
              const SizedBox(width: 8),
              Text(
                Helper.formatDate(
                  date: session.date,
                  pattern: 'dd MMM, yyyy',
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            '*Please share the OTP with the Therapist when the session has started',
            style: textTheme.caption,
          ),
        ],
      ),
    );
  }

  void startTimer() {
    if (duration.isNegative || duration == Duration.zero) {
      duration = Duration.zero;
      return;
    }

    _timer = Timer.periodic(oneSecond, (timer) {
      duration -= oneSecond;

      if (duration.isNegative || duration == Duration.zero) {
        duration = Duration.zero;
        _timer!.cancel();
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
