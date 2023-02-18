import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/main/home/booking/booking_screen.dart';
import 'package:alsan_app/ui/screens/main/home/select_clinicians_screen.dart';
import 'package:alsan_app/ui/screens/main/home/widgets/upcoming_sessions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/clinician_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> bannerList = [
    {
      'image': Images.topBanner1,
    },
    {
      'image': Images.topBanner2,
    }
  ];

  @override
  Widget build(BuildContext context) {
    var mainBloc = Provider.of<MainBloc>(context, listen: false);
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < 2; i++)
                GestureDetector(
                  onTap: () {
                    BookingScreen.open(context, clinician: Clinician());
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    child: Image.asset(
                      bannerList[i]['image'].toString(),
                      fit: BoxFit.fitWidth,
                      width: size.width * 0.9,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            BookingScreen.open(context, clinician: Clinician());
          },
          child: Image.asset(Images.midBanner),
        ),
        const SizedBox(height: 8),
        const UpcomingSessions(),
        const SizedBox(height: 8),
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
          height: 230,
          child: ClinicianList(
            scrollDirection: Axis.horizontal,
            onTap: (clinician) {
              BookingScreen.open(context, clinician: clinician);
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Resources",
          style: textTheme.bodyText1,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            mainBloc.changeIndex(3);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black.withOpacity(0.1),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                Images.resourcesBanner,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
