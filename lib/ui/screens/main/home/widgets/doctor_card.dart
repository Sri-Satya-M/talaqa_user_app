import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/image_from_net.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatefulWidget {
  final String name;
  final String image;
  final String languages;
  final String specialization;
  final int experience;

  const DoctorCard(
      {super.key,
      required this.name,
      required this.image,
      required this.languages,
      required this.specialization,
      required this.experience});

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return CustomCard(
      height: 220,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageFromNet(
                  imageUrl: widget.image,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  height: 100,
                  width: 100,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DetailsTile(
                      title: Text(
                        widget.name,
                        style: textTheme.headline2,
                      ),
                      value: Text(
                        widget.specialization,
                        style: textTheme.caption
                            ?.copyWith(color: MyColors.cerulean),
                      ),
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
                            '${widget.experience} years Exp.',
                            style: textTheme.subtitle2,
                          ),
                        ),
                        const SizedBox(width: 18),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Image.asset(
                          Images.voice,
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          widget.languages,
                          style: textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.navyBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: textTheme.headline3,
                fixedSize: const Size(140, 50),
              ),
              onPressed: () {},
              child: Text('Book a session'),
            ),
          ],
        ),
      ),
    );
  }
}
