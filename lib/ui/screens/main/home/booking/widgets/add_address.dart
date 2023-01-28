import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/address.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../location/location_screen.dart';
import 'address_list.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: true);
    return FutureBuilder<List<Address>>(
      future: userBloc.getAddresses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(error: snapshot.error);
        }
        if (!snapshot.hasData) return const LoadingWidget();
        var addresses = snapshot.data ?? [];
        if (addresses.isEmpty) return const EmptyWidget();

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Select your saved location',
                style: textTheme.caption?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 16),
              AddressList(addresses: addresses),
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
          ),
        );
      },
    );
  }
}
