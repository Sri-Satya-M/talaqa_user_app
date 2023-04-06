import 'package:alsan_app/model/address.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/images.dart';
import '../../../../widgets/details_tile.dart';

class AddressCard extends StatefulWidget {
  final Address address;
  final VoidCallback onTap;
  final bool enableDelete;
  final IconData suffixIcon;
  final Color suffixIconColor;

  const AddressCard({
    super.key,
    required this.address,
    required this.onTap,
    this.enableDelete = false,
    required this.suffixIcon,
    required this.suffixIconColor,
  });

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: MyColors.paleLightBlue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(Images.marker, width: 35, height: 35),
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailsTile(
                    title: Row(
                      children: [
                        Expanded(child: Text('${widget.address.addressLine1}')),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Icon(
                            widget.suffixIcon,
                            size: 20,
                            color: widget.suffixIconColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    value: Text(Address().formatAddress(widget.address)),
                  ),
                  Text('${widget.address.mobileNumber}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
