import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/progress_bloc.dart';
import '../../resources/colors.dart';
import 'error_snackbar.dart';

class CustomButton extends StatefulWidget {
  final Function? onPressed;
  final String text;
  final double? width;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.width,
  }) : super(key: key);

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  bool progress = false;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var progressBloc = Provider.of<ProgressBloc>(context, listen: false);
    return ElevatedButton(
      onPressed: widget.onPressed == null
          ? null
          : () async {
              if (progress || progressBloc.progress) return;
              setState(() => progress = true);
              progressBloc.enableProgress();
              try {
                await widget.onPressed!();
              } catch (e) {
                try {
                  ErrorSnackBar.show(context, e);
                } catch (error) {
                  print(error);
                }
              }
              progressBloc.disableProgress();
              if (!mounted) return;
              setState(() => progress = false);
            },
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MyColors.accentColor1,
              MyColors.accentColor2,
              MyColors.accentColor3,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Container(
          height: 60,
          width: widget.width ?? 80,
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: textTheme.headline5!.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
