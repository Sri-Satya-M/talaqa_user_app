import 'dart:async';

import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../resources/colors.dart';
import '../../../../resources/strings.dart';
import '../../../widgets/error_snackbar.dart';

class ResendOtpButton extends StatefulWidget {
  final String mobile;
  final Function onTap;

  const ResendOtpButton({
    Key? key,
    required this.mobile,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ResendOtpButton> createState() => _ResendOtpButtonState();
}

class _ResendOtpButtonState extends State<ResendOtpButton> {
  Timer? timer;
  int seconds = 0;
  int times = 0;

  void createTimer() {
    times++;
    seconds = 30;
    setState(() {});
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (seconds == 0) {
          timer.cancel();
        } else {
          seconds--;
        }
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    if (times > 2) {
      return TextButton(
        onPressed: null,
        child: Text(langBloc.getString(Strings.resend)),
      );
    }
    return TextButton(
      onPressed: seconds != 0
          ? null
          : () async {
              widget.onTap();
              ErrorSnackBar.show(
                context,
                'OTP sent to ${widget.mobile}',
              );
              createTimer();
            },
      child: Text(
        seconds != 0
            ? '${langBloc.getString(Strings.resend)} 00:${seconds.toString().padLeft(2, '0')}'
            : langBloc.getString(Strings.resend),
        style: textTheme.displaySmall!.copyWith(
          color: MyColors.primaryColor,
        ),
      ),
    );
  }
}
