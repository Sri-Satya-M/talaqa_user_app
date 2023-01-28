import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/sesssion_bloc.dart';
import '../../../../../../model/address.dart';
import 'address_details_widget.dart';

class AddressList extends StatefulWidget {
  final List<Address> addresses;

  const AddressList({super.key, required this.addresses});

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  int selectedAddress = -1;

  @override
  Widget build(BuildContext context) {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: widget.addresses.length,
      itemBuilder: (context, index) {
        var address = widget.addresses[index];
        return AddressDetailsWidget(
          address: address,
          isSelected: selectedAddress,
          onSelectAddress: (addressId) {
            selectedAddress = addressId as int;
            sessionBloc.setAddress(addressId: addressId);
            setState(() {});
          },
        );
      },
    );
  }
}
