import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/main/menu/my_address/my_adddress_screen.dart';
import 'package:alsan_app/ui/screens/main/menu/profile/profile_screen.dart';
import 'package:alsan_app/ui/screens/main/menu/profile/widget/menu_list.dart';
import 'package:alsan_app/ui/screens/main/menu/refer/refer_screen.dart';
import 'package:alsan_app/ui/screens/main/menu/reports/report_screen.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> userList = [
    {
      'image': Images.profileIcon,
      'title': 'Profile',
      'screen': ProfileScreen()
    },
    {
      'image': Images.address,
      'title': 'My Address',
      'screen': MyAddressScreen(),
    },
    {
      'image': Images.sessionsIcon,
      'title': 'My Sessions',
    },
    {
      'image': Images.reportIcon,
      'title': 'My Reports',
      'screen': ReportScreen()
    },
    {
      'image': Images.supportIcon,
      'title': 'Support',
      'screen': ProfileScreen()
    },
    {
      'image': Images.referIcon,
      'title': 'Refer a friend',
      'screen': ReferScreen(),
    },
    {
      'image': Images.faqIcon,
      'title': 'FAQ',
      'screen': ProfileScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: true);
    var mainBloc = Provider.of<MainBloc>(context, listen: false);
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
                url: userBloc.profile?.image,
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
          itemCount: 6,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8),
            child: MenuList(
              icon: userList[index]['image'],
              title: userList[index]['title'],
              onTap: () {
                switch (index) {
                  case 2:
                    mainBloc.changeIndex(2);
                    return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => userList[index]['screen'],
                  ),
                );
              },
            ),
          ),
          separatorBuilder: (context, index) => const Divider(),
        ),
        const SizedBox(height: 32),
        Text("Privacy Policy", style: textTheme.caption),
        const SizedBox(height: 16),
        Text("Terms of Use", style: textTheme.caption),
        const SizedBox(height: 16),
        Text("Cancellation & Refund Policy", style: textTheme.caption)
      ],
    );
  }
}
