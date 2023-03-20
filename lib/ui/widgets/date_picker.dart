import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../resources/images.dart';

class DatePicker extends StatelessWidget {
  DateTime? date;
  TextEditingController dateCtrl;
  final VoidCallback onDateChange;
  String? hintText;
  String? labelText;
  final DateTime? startDate;
  final DateTime? endDate;

  DatePicker(
    this.date, {
    Key? key,
    required this.dateCtrl,
    required this.onDateChange,
    this.hintText,
    this.labelText = 'Search for a date',
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return TextFormField(
      readOnly: true,
      controller: dateCtrl,
      style: textTheme.bodyText1!.copyWith(height: 44 / 20),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        date = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: startDate ?? DateTime(1947),
          lastDate: endDate ?? DateTime.now(),
        );
        dateCtrl.text = DateFormat('yyyy-MM-dd').format(date!);
        onDateChange.call();
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty && value == '') {
          return 'This field can\'t be empty';
        }
        return null;
      },
      onSaved: (v) => dateCtrl.text = v!,
      decoration: InputDecoration(
        hintText: hintText ?? '',
        labelText: labelText ?? '',
        suffixIcon: Row(
          children: [
            Image.asset(Images.calender),
          ],
        ),
        suffixIconConstraints: const BoxConstraints(
          maxWidth: 40,
          maxHeight: 20,
          minHeight: 20,
          minWidth: 20,
        ),
      ),
    );
  }
}
