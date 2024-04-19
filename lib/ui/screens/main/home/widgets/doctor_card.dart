import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/session_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/main/home/clinician_details_screen.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/image_from_net.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/clinicians.dart';
import '../../../../../resources/strings.dart';
import '../booking/booking_screen.dart';

class DoctorCard extends StatefulWidget {
  final Clinician clinician;

  const DoctorCard({super.key, required this.clinician});

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return CustomCard(
      width: size.width * 0.9,
      radius: 5,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          ClinicianDetailsScreen.open(context, clinician: widget.clinician);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImageFromNet(
                        imageUrl: widget.clinician.imageUrl,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DetailsTile(
                              title: Text(
                                widget.clinician.user?.fullName ?? ' NA',
                                style: textTheme.displayMedium,
                              ),
                              value: Text(
                                widget.clinician.designation ?? 'NA',
                                style: textTheme.bodySmall?.copyWith(
                                  color: MyColors.cerulean,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Row(
                            //   children: [
                            //     Container(
                            //       padding: const EdgeInsets.symmetric(
                            //         vertical: 5,
                            //         horizontal: 10,
                            //       ),
                            //       decoration: const BoxDecoration(
                            //         color: MyColors.paleBlue,
                            //         borderRadius: BorderRadius.all(
                            //           Radius.circular(25),
                            //         ),
                            //       ),
                            //       child: Text(
                            //         '${widget.clinician.experience} years Exp.',
                            //         style: textTheme.titleSmall,
                            //       ),
                            //     ),
                            //     const SizedBox(width: 18),
                            //   ],
                            // ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Image.asset(Images.voice,
                                    height: 16, width: 16,),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.clinician.languagesKnown ?? 'NA',
                                    style: textTheme.bodyLarge,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                // textStyle: textTheme.displaySmall,
                fixedSize: const Size(140, 50),
              ),
              onPressed: () {
                var sessionBloc = Provider.of<SessionBloc>(
                  context,
                  listen: false,
                );
                BookingScreen.open(context, isClinician: true);
                print('Heref ${widget.clinician.userId}');
                sessionBloc.selectedClinician = widget.clinician;
                print(sessionBloc.selectedClinician);
              },
              child: Text(langBloc.getString(Strings.bookASession)),
            ),
          ],
        ),
      ),
    );
  }
}
