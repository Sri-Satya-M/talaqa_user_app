import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/address.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/images.dart';
import '../../../../../widgets/details_tile.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../location/location_screen.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  int selectedAddress = -1;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: true);
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    return FutureBuilder<List<Address>>(
      future: userBloc.getAddresses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(error: snapshot.error);
        }
        if (!snapshot.hasData) return const LoadingWidget();
        var addresses = snapshot.data ?? [];
        if (addresses.isEmpty) return const EmptyWidget();

        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Select your saved location',
              style: textTheme.caption?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                var address = addresses[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectedAddress = index;
                        sessionBloc.selectedAddressId = address.id;
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
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
                                      formatAddress(address),
                                    ),
                                  ),
                                  const Text('7702165416'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Radio(
                                value: index,
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
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                await LocationScreen.open(context);
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
      },
    );
  }

  String formatAddress(Address address) {
    String formattedAddress = '';
    formattedAddress +=
        address.addressLine1 == null ? '' : '${address.addressLine1!}, ';
    formattedAddress +=
        address.addressLine2 == null ? '' : '${address.addressLine2!}, ';
    formattedAddress += address.city == null ? '' : '${address.city!}, ';
    formattedAddress += address.country == null ? '' : '${address.country!}, ';
    formattedAddress += address.pincode == null ? '' : '${address.pincode!}, ';
    return formattedAddress;
  }
}
