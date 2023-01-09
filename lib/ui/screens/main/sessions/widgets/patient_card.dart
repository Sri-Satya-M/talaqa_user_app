import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
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
                Text("ALSOO34"),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.yellow,
                    foregroundColor: MyColors.secondaryColor,
                    fixedSize: const Size(140, 40),
                  ),
                  child: Text(
                    'Pending',
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
