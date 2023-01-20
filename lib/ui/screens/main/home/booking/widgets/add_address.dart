import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';

import '../../../../../../resources/images.dart';
import '../../../../../widgets/details_tile.dart';
import 'add_location_screen.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  int selectedAddress = -1;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Select your saved location',
          style: textTheme.caption?.copyWith(color: Colors.black),
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            selectedAddress = 0;
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.asset(
                    Images.marker,
                    width: 20,
                    height: 20,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      DetailsTile(
                        title: Text('Kondapur'),
                        value: Text(
                          'Road no 23, BP raja Marg, Whitefields, Kondapur,Hyderabad - 500081',
                        ),
                      ),
                      Text('7702165416'),
                    ],
                  ),
                ),
                Expanded(
                  child: Radio(
                    value: 0,
                    groupValue: selectedAddress,
                    onChanged: (value) {
                      selectedAddress = value as int;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            AddLocationScreen.open(context);
          },
          child: Container(
            height: 80,
            padding: const EdgeInsets.all(16),
            decoration: DottedDecoration(
              shape: Shape.box,
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: Colors.black.withOpacity(0.2),
                ),
                Text(
                  '+ Add New Address',
                  style: textTheme.caption,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
