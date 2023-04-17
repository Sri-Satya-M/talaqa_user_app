import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/main/home/booking/booking_screen.dart';
import 'package:alsan_app/ui/screens/main/home/select_clinicians_screen.dart';
import 'package:alsan_app/ui/screens/main/home/widgets/upcoming_sessions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/clinician_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var banners = [Images.topBanner1];
  int bannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    var mainBloc = Provider.of<MainBloc>(context, listen: false);
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      physics: const ScrollPhysics(),
      children: [
        CarouselSlider(
          items: [
            for (int i = 0; i < banners.length; i++)
              GestureDetector(
                onTap: () => bookNow.call(index: i),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    banners[i],
                    fit: BoxFit.fitWidth,
                    width: size.width * 0.9,
                  ),
                ),
              ),
          ],
          options: CarouselOptions(
              height: 160,
              aspectRatio: 16 / 9,
              viewportFraction: 0.99,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              onPageChanged: (index, _) {
                setState(() {
                  bannerIndex = index;
                });
              }),
        ),
        const SizedBox(height: 8),
        const UpcomingSessions(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Featured Clinicians", style: textTheme.bodyText1),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectClinicians()),
                );
              },
              child: Text(
                "See all",
                style: textTheme.headline2?.copyWith(
                  color: MyColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 200,
          child: ClinicianList(
            scrollDirection: Axis.horizontal,
            onTap: (clinician) {
              BookingScreen.open(context, clinician: clinician);
            },
          ),
        ),
        const SizedBox(height: 16),
        Text("Resources", style: textTheme.bodyText1),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => mainBloc.changeIndex(3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                width: 1,
                color: Colors.black.withOpacity(0.1),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(Images.resourcesBanner),
            ),
          ),
        ),
      ],
    );
  }

  bookNow({required int index}) {
    switch (index) {
      case 0:
        BookingScreen.open(context, clinician: Clinician());
        break;
      default:
        return;
    }
  }
}
