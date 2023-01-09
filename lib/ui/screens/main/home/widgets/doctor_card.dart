import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/image_from_net.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatefulWidget {
  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ImageFromNet(
                  imageUrl:
                      'https://miro.medium.com/fit/c/88/88/1*0HhsaB_S9yiF-hi9AESZTg.jpeg',
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const DetailsTile(
                      title: Text("Dr. Akbar"),
                      value: Text("Language therapist"),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: const BoxDecoration(
                            color: MyColors.paleBlue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: Text(
                            "8 years Exp.",
                            style: textTheme.subtitle2,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Row(
                          children: const [
                            Icon(
                              Icons.star,
                              color: MyColors.cerulean,
                              size: 15,
                            ),
                            Text("5.0")
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.school),
                const SizedBox(width: 8),
                Text(
                  "MBBS, MS, SLP",
                  style: textTheme.subtitle1,
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.school),
                const SizedBox(width: 8),
                Text(
                  "MBBS, MS, SLP",
                  style: textTheme.subtitle1,
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.school),
                const SizedBox(width: 8),
                Text(
                  "MBBS, MS, SLP",
                  style: textTheme.subtitle1,
                )
              ],
            ),
            const SizedBox(height: 14),
            Text(
              "Consultation Starting from 400 AED",
              style: textTheme.subtitle2,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(160, 40),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.video_call),
                      SizedBox(width: 5),
                      Text(
                        'Book Online',
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(170, 40),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.home),
                      SizedBox(width: 5),
                      Text('Book Offline'),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
