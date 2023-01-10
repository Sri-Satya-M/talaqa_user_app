import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/ui/widgets/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TermsConditions extends StatefulWidget {
  static Future open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TermsConditions(),
      ),
    );
  }

  const TermsConditions({super.key});

  @override
  _TermsConditionsState createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  bool check = false;
  late bool isEmail;

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    isEmail = userBloc.username.contains("@");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            Image.asset(Images.logo, height: 60, width: 200),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withOpacity(0.15),
                    width: 1.5,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView(
                    padding: const EdgeInsets.all(25),
                    children: const [
                      Text(
                        "Terms and Conditions\n",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Etiam facilisis ligula nec velit posuere egestas. Nunc dictum lectus sem, vel dignissim purus luctus quis. Vestibulum et ligula suscipit, hendrerit erat a, ultricies velit. Praesent convallis in lorem nec blandit. Phasellus a porta tellus. Suspendisse sagittis metus enim. Sed molestie libero id sem pulvinar, quis euismod mauris suscipit. Etiam facilisis ligula nec velit posuere egestas. Nunc dictum lectus sem, vel dignissim purus luctus quis. Vestibulum et ligula suscipit, hendrerit erat a, ultricies velit. Praesent convallis in lorem nec blandit. Phasellus a porta tellus. Suspendisse sagittis metus enim. Sed molestie libero id sem pulvinar, quis euismod mauris suscipit. Etiam facilisis ligula nec velit posuere egestas. Nunc dictum lectus sem, vel dignissim purus luctus quis. Vestibulum et ligula suscipit, hendrerit erat a, ultricies velit. Praesent convallis in lorem nec blandit. Phasellus a porta tellus. Suspendisse sagittis metus enim. Sed molestie libero id sem pulvinar, quis euismod mauris suscipit. Etiam facilisis ligula nec velit posuere egestas. Nunc dictum lectus sem, vel dignissim purus luctus quis. Vestibulum et ligula suscipit, hendrerit erat a, ultricies Etiam facilisis ligula nec velit posuere egestas. Nunc dictum lectus sem, vel dignissim purus luctus quis. Vestibulum et ligula suscipit, hendrerit erat a, ultricies velit. Praesent convallis in lorem nec blandit. Phasellus a porta tellus. Suspendisse sagittis metus enim. Sed molestie libero id sem pulvinar, quis euismod mauris suscipit. Etiam facilisis ligula nec velit posuere egestas. Nunc dictum lectus sem, vel dignissim purus luctus quis. Vestibulum et ligula suscipit, hendrerit erat a, ultricies velit. Praesent convallis in lorem nec blandit. Phasellus a porta tellus. Suspendisse sagittis metus enim. Sed molestie libero id sem pulvinar, quis euismod mauris suscipit. Etiam facilisis ligula nec velit posuere egestas. Nunc dictum lectus sem, vel dignissim purus luctus quis. Vestibulum et ligula suscipit, hendrerit erat a, ultricies velit. Praesent convallis in lorem nec blandit. Phasellus a porta tellus. Suspendisse sagittis metus enim. Sed molestie libero id sem pulvinar, quis euismod mauris suscipit. Etiam facilisis ligula nec velit posuere egestas. Nunc dictum lectus sem, vel dignissim purus luctus quis. Vestibulum et ligula suscipit, hendrerit erat a, ultricies",
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: check,
                  onChanged: (value) {
                    setState(() {
                      check = value as bool;
                    });
                  },
                ),
                const Text("I agree to the terms and conditions")
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: (!check)
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 32,
              ),
              child: ProgressButton(
                onPressed: () {
                  var message = isEmail
                      ? "Your Email Id has been \n Successfully Verified"
                      : "Your Mobile Number has been \n Successfully Verified";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuccessScreen(
                        message: message,
                        type: isEmail ? 'EMAIL' : 'MOBILE',
                      ),
                    ),
                  );
                },
                child: const Text("Proceed"),
              ),
            ),
    );
  }
}
