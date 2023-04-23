import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/address.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/strings.dart';
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
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return FutureBuilder<List<Address>>(
      future: userBloc.getAddresses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(error: snapshot.error);
        }
        if (!snapshot.hasData) return const LoadingWidget();
        var addresses = snapshot.data ?? [];

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
                langBloc.getString(Strings.selectYourSavedLocation),
                style: textTheme.caption?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 16),
              if (addresses.isNotEmpty) AddressList(addresses: addresses),
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
                        '+ ${langBloc.getString(Strings.addNewAddress)}',
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
