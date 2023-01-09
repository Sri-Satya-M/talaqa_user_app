import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  final TextEditingController timeCtrl;
  final VoidCallback onTimeChange;
  String? hintText;
  String? labelText;
  TimeOfDay? time;

  TimePicker(
    this.time, {
    Key? key,
    required this.timeCtrl,
    required this.onTimeChange,
    this.hintText,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return TextFormField(
      readOnly: true,
      controller: timeCtrl,
      style: textTheme.bodyText1!.copyWith(height: 44 / 20),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        time = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 1, minute: 0),
          initialEntryMode: TimePickerEntryMode.dial,
          builder: (context, child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child ?? Container(),
            );
          },
        );
        timeCtrl.text = time == null
            ? ''
            : '${time?.hour.toString().padLeft(2, '0') ?? ''}:${time?.minute.toString().padLeft(2, '0') ?? ''}';

        onTimeChange();
      },
      validator: (value) {
        if (value == null) {
          return 'This field can\'t be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText ?? '',
        labelText: labelText ?? '',
        suffixIcon: const Icon(
          Icons.access_time_rounded,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }
}
