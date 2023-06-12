import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/resources/strings.dart';
import 'package:alsan_app/ui/screens/language/language_screen.dart';
import 'package:alsan_app/ui/screens/main/menu/faq/faq_screen.dart';
import 'package:alsan_app/ui/screens/main/menu/my_address/my_adddress_screen.dart';
import 'package:alsan_app/ui/screens/main/menu/profile/profile_screen.dart';
import 'package:alsan_app/ui/screens/main/menu/profile/widget/menu_list.dart';
import 'package:alsan_app/ui/screens/main/menu/reports/report_screen.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../bloc/language_bloc.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: true);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    List<Map<String, dynamic>> userList = [
      {
        'image': Images.profileIcon,
        'title': langBloc.getString(Strings.profile),
      },
      {
        'image': Images.address,
        'title': langBloc.getString(Strings.myAddress),
      },
      {
        'image': Images.sessionsIcon,
        'title': langBloc.getString(Strings.mySessions),
      },
      {
        'image': Images.reportIcon,
        'title': langBloc.getString(Strings.myReports),
      },
      {
        'image': Images.language,
        'title': langBloc.getString(Strings.yourLanguage),
      },
      // {
      //   'image': Images.supportIcon,
      //   'title': langBloc.getString(Strings.support),
      // },
      // {
      //   'image': Images.referIcon,
      //   'title': langBloc.getString(Strings.referAFriend),
      // },
      // {
      //   'image': Images.faqIcon,
      //   'title': langBloc.getString(Strings.faq),
      // },
    ];
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MyColors.profileCardColor,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Avatar(
                url: userBloc.profile?.imageUrl,
                name: userBloc.profile?.user?.fullName,
                borderRadius: const BorderRadius.all(Radius.circular(35)),
                size: 75,
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userBloc.profile?.user?.fullName ?? 'NA',
                    style: textTheme.headline4,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      Helper.textCapitalization(
                        text: userBloc.profile?.gender ?? 'NA',
                      ),
                      style: textTheme.subtitle2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: userList.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8),
            child: MenuList(
              icon: userList[index]['image'],
              title: userList[index]['title'],
              onTap: () => onTap.call(index),
            ),
          ),
          separatorBuilder: (context, index) => const Divider(),
        ),
        const SizedBox(height: 32),
        Text(
          langBloc.getString(Strings.privacyPolicy),
          style: textTheme.caption,
        ),
        const SizedBox(height: 16),
        Text(langBloc.getString(Strings.termsOfUse), style: textTheme.caption),
        const SizedBox(height: 16),
        Text(
          langBloc.getString(Strings.cancellationRefundPolicy),
          style: textTheme.caption,
        )
      ],
    );
  }

  onTap(int index) {
    var mainBloc = Provider.of<MainBloc>(context, listen: false);
    var screen;
    switch (index) {
      case 0:
        screen = const ProfileScreen();
        break;
      case 1:
        screen = const MyAddressScreen();
        break;
      case 2:
        mainBloc.tabController = TabController(
          initialIndex: 0,
          length: mainBloc.tabLength(2),
          vsync: this,
        );
        return mainBloc.changeIndex(2);
      case 3:
        screen = const ReportScreen();
        break;
      case 4:
        screen = const LanguageScreen(isLoggingIn: false);
        break;
      case 5:
        return;
      case 6:
        return;
      case 7:
        FAQScreen.open(context);
        break;
      default:
        return;
    }

    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((value) => setState(() {}));
  }
}
