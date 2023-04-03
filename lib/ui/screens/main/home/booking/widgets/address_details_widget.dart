import 'package:alsan_app/model/address.dart';
import 'package:flutter/material.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/images.dart';
import '../../../../../widgets/details_tile.dart';

class AddressDetailsWidget extends StatefulWidget {
  final Address address;
  final int isSelected;
  final VoidCallback? onTapNavigation;
  final Function? onSelectAddress;

  const AddressDetailsWidget({
    super.key,
    required this.address,
    required this.isSelected,
    this.onTapNavigation,
    this.onSelectAddress,
  });

  @override
  State<AddressDetailsWidget> createState() => _AddressDetailsWidgetState();
}

class _AddressDetailsWidgetState extends State<AddressDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onSelectAddress != null) {
          widget.onSelectAddress!(widget.address);
        } else if (widget.onTapNavigation != null) {
          widget.onTapNavigation!();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: (widget.address.id == widget.isSelected)
                ? MyColors.primaryColor
                : Colors.transparent,
          ),
          color: MyColors.paleLightBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(Images.marker, width: 20, height: 20),
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailsTile(
                    title: Text('${widget.address.addressLine1}'),
                    value: Text(
                      Address().formatAddress(widget.address),
                    ),
                  ),
                  Text('${widget.address.mobileNumber}'),
                ],
              ),
            ),
            if (widget.onSelectAddress != null) ...[
              Expanded(
                child: Radio(
                  value: widget.address.id,
                  groupValue: widget.isSelected,
                  onChanged: (value) {
                    widget.onSelectAddress!(value as int);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
