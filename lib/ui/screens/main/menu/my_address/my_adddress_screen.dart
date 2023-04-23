import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/address.dart';
import 'package:alsan_app/ui/screens/main/sessions/widgets/address_card.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../resources/strings.dart';
import '../../../../widgets/dialog_confirm.dart';
import '../../../../widgets/error_snackbar.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../../../location/location_screen.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  _MyAddressScreenState createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: true);
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.myAddresses))),
      body: ListView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTap: () async {
              await LocationScreen.open(context).then(
                (value) => setState(() {}),
              );
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
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Address>>(
            future: userBloc.getAddresses(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return CustomErrorWidget(error: snapshot.error);
              }

              if (!snapshot.hasData) return const LoadingWidget();

              var addressList = snapshot.data ?? [];

              if (addressList.isEmpty) return const SizedBox();

              return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: addressList.length,
                itemBuilder: (context, index) {
                  return AddressCard(
                    address: addressList[index],
                    onTap: () async {
                      bool? confirm = await ConfirmDialog.show(
                        context,
                        message:
                            '${langBloc.getString(Strings.confirmToDeleteAddress)}?',
                      );

                      if (confirm == true) {
                        var response = await userBloc.removeAddresses(
                          id: addressList[index].id.toString(),
                        ) as Map<String, dynamic>;

                        if (response.containsKey('status') &&
                            response['status'] == 'success') {
                          ErrorSnackBar.show(context, response['message']);
                          setState(() {});
                        }
                      }
                    },
                    suffixIcon: Icons.delete,
                    suffixIconColor: Colors.redAccent,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
