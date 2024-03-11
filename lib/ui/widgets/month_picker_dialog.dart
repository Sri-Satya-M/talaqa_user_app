import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

class MonthPickerDialog extends StatefulWidget {
  final DateTime? fromDate;
  final DateTime? toDate;

  const MonthPickerDialog({Key? key, this.fromDate, this.toDate})
      : super(key: key);

  static Future open(BuildContext context, DateTime fromDate) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            MonthPickerDialog(fromDate: fromDate),
          ],
        );
      },
    );
  }

  @override
  _MonthPickerDialogState createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  DateTime selectedDate = DateTime.now();
  DateTime? toDate;
  dp.DatePeriod? selectedPeriod;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.fromDate!;
    toDate = widget.toDate;
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        dp.MonthPicker.single(
          onChanged: (DateTime v) {
            setState(() {
              print(v);
              selectedDate = v;
            });
          },
          selectedDate: selectedDate,
          datePickerStyles:
              dp.DatePickerStyles(selectedDateStyle: textTheme.bodyMedium),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, selectedDate);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
