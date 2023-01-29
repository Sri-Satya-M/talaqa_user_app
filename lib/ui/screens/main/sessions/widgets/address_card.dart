import 'package:alsan_app/model/address.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/images.dart';
import '../../../../widgets/details_tile.dart';

class AddressCard extends StatelessWidget {
  final Address address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                children: [
                  DetailsTile(
                    title: Text('${address.addressLine1}'),
                    value: Text(
                      Address().formatAddress(address),
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
