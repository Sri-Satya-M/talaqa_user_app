import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/menu/reports/widgets/time_slot.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:flutter/material.dart';

class PatientCard extends StatefulWidget {
  @override
  _PatientCardState createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ALSOO34",
                  style: textTheme.headline4,
                ),
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: MyColors.yellow,
                    backgroundColor: MyColors.yellow,
                    foregroundColor: MyColors.secondaryColor,
                    fixedSize: const Size(140, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'PENDING',
                    style: textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Avatar(
                  url:
                      'https://miro.medium.com/fit/c/88/88/1*0HhsaB_S9yiF-hi9AESZTg.jpeg',
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                const SizedBox(width: 8),
                DetailsTile(
                  title: const Text("Dr. Ruchika Mittal"),
                  value: Text(
                    "20 years exp",
                    style: textTheme.caption,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Patient", style: textTheme.caption),
                    const SizedBox(height: 4),
                    Text(
                      "ALex Oliver",
                      style: textTheme.headline3
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(width: 102),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Speciality", style: textTheme.caption),
                    const SizedBox(height: 4),
                    Text(
                      "Speech Therapy",
                      style: textTheme.headline3
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text("Mode of consultation", style: textTheme.caption),
            const SizedBox(height: 5),
            Text(
              "At Home",
              style: textTheme.headline3?.copyWith(fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 14),
            TimeSlot()
          ],
        ),
      ),
    );
  }
}
