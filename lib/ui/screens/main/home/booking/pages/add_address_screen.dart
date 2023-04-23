import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/location_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/strings.dart';
import '../../../../../widgets/error_snackbar.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({
    super.key,
  });

  static Future open(
    BuildContext context,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddAddressScreen(),
      ),
    );
  }

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  var addressLine1 = '';
  var addressLine2 = '';
  var pincode = '';
  var landmark = '';
  var city = '';
  var country = '';
  var mobileNumber = '';

  final formKey = GlobalKey<FormState>();

  initialize(Placemark? address) async {
    if (address != null) {
      addressLine1 = address.name!;
      addressLine2 = address.street!;
      landmark = address.subLocality!;
      pincode = address.postalCode!;
      city = address.locality!;
      country = address.country!;
    }
  }

  @override
  Widget build(BuildContext context) {
    var locationBloc = Provider.of<LocationBloc>(context, listen: true);
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    initialize(locationBloc.address);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.addLocation))),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                langBloc.getString(Strings.enterYourLocationDetails),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: addressLine1,
                onChanged: (value) {
                  setState(() {
                    addressLine1 = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "${langBloc.getString(Strings.addressLine1)}*",
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.enterTheAddressLine1);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: addressLine2,
                onChanged: (value) {
                  setState(() {
                    addressLine2 = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: langBloc.getString(Strings.addressLine2),
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: landmark,
                onChanged: (value) {
                  setState(() {
                    landmark = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: langBloc.getString(Strings.landmark),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.enterLandmark);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: city,
                onChanged: (value) {
                  setState(() {
                    city = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "${langBloc.getString(Strings.city)}*",
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.enterCity);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: pincode,
                onChanged: (value) {
                  setState(() {
                    pincode = value;
                  });
                },
                decoration: InputDecoration(
                    hintText: "${langBloc.getString(Strings.pincode)}*"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return langBloc.getString(Strings.enterPincode);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: country,
                onChanged: (value) {
                  setState(() {
                    country = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: langBloc.getString(Strings.country),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.enterCountry);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: mobileNumber,
                onChanged: (value) {
                  setState(() {
                    mobileNumber = value;
                  });
                },
                decoration: InputDecoration(
                    hintText: langBloc.getString(Strings.mobileNumber)),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.enterTheMobileNumber);
                  } else if (value.length < 10) {
                    return langBloc.getString(Strings.enter10DigitMobileNumber);
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ProgressButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) {
              ErrorSnackBar.show(
                context,
                langBloc.getString(Strings.fillMandatoryFields),
              );
              return null;
            }

            var body = {
              'addressLine1': addressLine1,
              'addressLine2': addressLine2,
              'pincode': pincode,
              'landmark': landmark,
              "city": city,
              "country": country,
              'mobileNumber': mobileNumber,
              'latitude': locationBloc.currentPosition!.latitude.toString(),
              'longitude': locationBloc.currentPosition!.longitude.toString(),
            };

            var address = await userBloc.postAddress(body: body);
            if (address.id != null) {
              Navigator.pop(context, true);
            }
          },
          color: MyColors.primaryColor,
          child: Text(langBloc.getString(Strings.submit)),
        ),
      ),
    );
  }
}
