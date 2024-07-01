import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/main/home/booking/booking_screen.dart';
import 'package:alsan_app/ui/screens/main/home/select_clinicians_screen.dart';
import 'package:alsan_app/ui/screens/main/home/widgets/upcoming_sessions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../bloc/language_bloc.dart';
import '../../../../resources/strings.dart';
import 'widgets/clinician_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // var banners = [Images.topBanner1];
  var banners = [Images.talaqaBanner];
  int bannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var mainBloc = Provider.of<MainBloc>(context, listen: false);
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      physics: const ScrollPhysics(),
      children: [
        Stack(
          children: [
            Image.asset(Images.talaqaBanner, width: double.maxFinite),
            Positioned(
              top: 20,
              left: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    langBloc.getString(Strings.speechTherapy),
                    style: textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "at Your Fingertips",
                    style: textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                width: 110,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () => bookNow.call(index: 0),
                  child: Center(
                    child: Text(
                      langBloc.getString(Strings.bookNow),
                      style: textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        UpcomingSessions(
          onTap: () {
            mainBloc.tabController = TabController(
              initialIndex: 0,
              length: mainBloc.tabLength(2),
              vsync: this,
            );
            mainBloc.changeIndex(2);
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              langBloc.getString(Strings.featuredClinicians),
              style: textTheme.bodyLarge,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectClinicians(),
                  ),
                );
              },
              child: Text(langBloc.getString(Strings.seeAll)),
            ),
          ],
        ),
        const SizedBox(
          height: 192,
          child: ClinicianList(scrollDirection: Axis.horizontal),
        ),
        const SizedBox(height: 16),
        Text(langBloc.getString(Strings.resources), style: textTheme.bodyLarge),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            mainBloc.tabController = TabController(
              initialIndex: 0,
              length: mainBloc.tabLength(3),
              vsync: this,
            );
            mainBloc.changeIndex(3);
          },
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
        BookingScreen.open(context);
        break;
      default:
        return;
    }
  }
}
