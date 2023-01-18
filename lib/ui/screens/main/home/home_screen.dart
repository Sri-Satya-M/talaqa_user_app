import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/home/select_clinicians_screen.dart';
import 'package:alsan_app/ui/screens/main/home/widgets/clinician_api_card.dart';
import 'package:alsan_app/ui/screens/main/sessions/widgets/patient_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 20, 14, 10),
          decoration: BoxDecoration(
            color: MyColors.paleBlue,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: 140,
          width: 320,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Speech Therapy",
                    style: textTheme.subtitle2,
                  ),
                  Text(
                    "at your Fingertips",
                    style: textTheme.headline6,
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Featured Clinicians",
              style: textTheme.bodyText1,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectClinicians(),
                  ),
                );
              },
              child: Text(
                "See all",
                style:
                    textTheme.headline2?.copyWith(color: MyColors.primaryColor),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 300,
          child: ClinicianAPiCard(
            scrollDirection: Axis.horizontal,
          ),
        ),
        PatientCard()
      ],
    );
  }
}
