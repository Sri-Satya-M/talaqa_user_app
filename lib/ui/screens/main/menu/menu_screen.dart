import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/main/menu/profile/profile_screen.dart';
import 'package:alsan_app/ui/widgets/image_from_net.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          decoration: BoxDecoration(
            color: MyColors.paleBlue,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: 140,
          width: 320,
          child: Row(
            children: [
              const ImageFromNet(
                imageUrl:
                    'https://miro.medium.com/fit/c/88/88/1*0HhsaB_S9yiF-hi9AESZTg.jpeg',
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Marshall Mathers",
                    style: textTheme.headline4,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(3)),
                    child: Text("Male", style: textTheme.subtitle2),
                  ),
                ],
              )
            ],
          ),
        ),
        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            Images.profileIcon,
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 14),
                          const Text("Profile"),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: MyColors.divider,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ],
                  ),
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: 6),
        const Divider(),
        const SizedBox(height: 20),
        Text("Privacy Policy", style: textTheme.subtitle1),
        const SizedBox(height: 14),
        Text("Terms of Use", style: textTheme.subtitle1),
        const SizedBox(height: 14),
        Text("Cancellation & Refund Policy", style: textTheme.subtitle1)
      ],
    );
  }
}
