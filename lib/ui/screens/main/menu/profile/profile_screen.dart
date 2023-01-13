import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/menu/profile/edit_profile_screen.dart';
import 'package:alsan_app/ui/screens/main/menu/profile/patient_profiles_screen.dart';
import 'package:alsan_app/ui/screens/main/menu/profile/widget/session_details_card.dart';
import 'package:alsan_app/ui/screens/splash/splash_screen.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/dynamic_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../resources/images.dart';
import '../../../../widgets/confirm_logout.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            decoration: BoxDecoration(
              color: MyColors.profileCardColor,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            width: double.maxFinite,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Avatar(
                            url:
                                'https://miro.medium.com/fit/c/88/88/1*0HhsaB_S9yiF-hi9AESZTg.jpeg',
                            name: 'Marshall Mathers',
                            borderRadius: BorderRadius.circular(35),
                            size: 70,
                          ),
                          const SizedBox(width: 12),
                          DetailsTile(
                            title: const Text('Marshall Mathers'),
                            value: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text("Male", style: textTheme.subtitle2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Image.asset(
                            Images.phone,
                            width: 16,
                          ),
                          const SizedBox(width: 12),
                          const Text('+91 1234567890')
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(
                            Images.email,
                            width: 16,
                          ),
                          const SizedBox(width: 12),
                          const Text('rishab@janaspandana.in')
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(),
                        ),
                      );
                    },
                    child: Text(
                      "Edit",
                      style: textTheme.subtitle1?.copyWith(
                        color: MyColors.cerulean,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 18),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(Images.patient, width: 18),
                    SizedBox(width: 12),
                    Text("View Patient Profiles"),
                  ],
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: MyColors.divider,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    iconSize: 14,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientProfile(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text("Session Analystics", style: textTheme.headline2),
          SizedBox(height: 14),
          Text(
            "Session Details",
            style: textTheme.subtitle2?.copyWith(
              color: Colors.black.withOpacity(1),
            ),
          ),
          SizedBox(height: 10),
          DynamicGridView(
              spacing: 0,
              children: [
                SessionCard(),
                SessionCard(),
                SessionCard(),
              ],
              count: 2),
          SizedBox(height: 24),
          Text(
            "Mode of Consultaion",
            style: textTheme.subtitle2?.copyWith(
              color: Colors.black.withOpacity(1),
            ),
          ),
          SizedBox(height: 10),
          DynamicGridView(
              spacing: 0,
              children: [
                SessionCard(),
                SessionCard(),
              ],
              count: 2),
          SizedBox(height: 24),
          Text(
            "Session Information",
            style: textTheme.subtitle2?.copyWith(
              color: Colors.black.withOpacity(1),
            ),
          ),
          SizedBox(height: 10),
          DynamicGridView(
              spacing: 0,
              children: [
                SessionCard(),
                SessionCard(),
                SessionCard(),
              ],
              count: 2),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () async {
              bool? isConfirm = await ConfirmLogout.open(context);
              print(isConfirm);
              if (isConfirm ?? false) {
                userBloc.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
