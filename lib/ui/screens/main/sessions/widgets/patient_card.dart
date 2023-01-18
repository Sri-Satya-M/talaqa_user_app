import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/menu/reports/widgets/time_slot.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/dynamic_grid_view.dart';
import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
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
                Container(
                  decoration: const BoxDecoration(
                    color: MyColors.yellow,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  child: Text(
                    'PENDING',
                    style: textTheme.bodyText1,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Avatar(
                  url:
                      'https://miro.medium.com/fit/c/88/88/1*0HhsaB_S9yiF-hi9AESZTg.jpeg',
                  borderRadius: BorderRadius.all(Radius.circular(20)),
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
            DynamicGridView(
              spacing: 5,
              count: 2,
              children: [
                ReverseDetailsTile(
                  title: Text("Patient", style: textTheme.caption),
                  value: Text(
                    "ALex Oliver",
                    style: textTheme.headline3
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                ReverseDetailsTile(
                  title: Text("Mode of consultation", style: textTheme.caption),
                  value: Text(
                    "ALex Oliver",
                    style: textTheme.headline3
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                ReverseDetailsTile(
                  title: Text("Speciality", style: textTheme.caption),
                  value: Text(
                    "Speech Therapy",
                    style: textTheme.headline3
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TimeSlot()
          ],
        ),
      ),
    );
  }
}
