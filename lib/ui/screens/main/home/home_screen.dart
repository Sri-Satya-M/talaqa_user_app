import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/home/widgets/doctor_card.dart';
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
        DoctorCard(),
        PatientCard()
      ],
    );
  }
}
