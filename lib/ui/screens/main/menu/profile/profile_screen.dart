import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/images.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            decoration: BoxDecoration(
              color: MyColors.profileCard,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            width: double.maxFinite,
            child: Stack(
              children: [
                ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
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
                        const Text('rishab@janaspandanain')
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {},
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
        ],
      ),
    );
  }
}
