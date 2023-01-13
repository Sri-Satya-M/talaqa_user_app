import 'package:alsan_app/resources/colors.dart';
import 'package:flutter/material.dart';

class MenuList extends StatefulWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const MenuList(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              widget.icon,
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 14),
            Text(widget.title),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: MyColors.divider,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: widget.onTap,
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ],
    );
  }
}
