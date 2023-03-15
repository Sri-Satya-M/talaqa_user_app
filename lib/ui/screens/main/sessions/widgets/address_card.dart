import 'package:alsan_app/model/address.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/images.dart';
import '../../../../widgets/details_tile.dart';

class AddressCard extends StatefulWidget {
  final Address address;
  final VoidCallback onTap;

  const AddressCard({super.key, required this.address, required this.onTap});

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
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: MyColors.divider),
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
                children: [
                  DetailsTile(
                    title: Row(
                      children: [
                        Expanded(child: Text('${widget.address.addressLine1}')),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Icon(Icons.delete, size: 20),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    value: Text(
                      Address().formatAddress(widget.address),
                    ),
                  ),
                  const Text('7702165416'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
