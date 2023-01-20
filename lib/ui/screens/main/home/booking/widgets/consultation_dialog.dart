import 'package:alsan_app/resources/colors.dart';
import 'package:flutter/material.dart';

import '../../../../../widgets/details_tile.dart';

class ConsultationDialog extends StatefulWidget {
  static Future open(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Row(
            children: [
              Text('Mode of Consultation', style: textTheme.headline4),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          elevation: 5,
          content: ConsultationDialog(),
        );
      },
    );
  }

  @override
  _ConsultationDialogState createState() => _ConsultationDialogState();
}

class _ConsultationDialogState extends State<ConsultationDialog> {
  var consultations = [
    'Video Call Consultation Fee',
    'Audio Call Consultation Fee',
    'At Home Consultation Fee'
  ];
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.maxFinite,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        children: [
          const Divider(),
          const SizedBox(height: 8),
          for (int i = 0; i < consultations.length; i++)
            GestureDetector(
              onTap: () {
                setState(() {
                  selected = i;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: (selected == i)
                        ? MyColors.primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    DetailsTile(
                      title: Text(consultations[i]),
                      value: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: MyColors.lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Text('100 Dirham'),
                      ),
                    ),
                    const Spacer(),
                    Radio(
                      value: i,
                      groupValue: selected,
                      onChanged: (value) {
                        setState(() {
                          selected = value as int;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'HOME');
              },
              child: const Text('Book Now'),
            ),
          ),
        ],
      ),
    );
  }
}
