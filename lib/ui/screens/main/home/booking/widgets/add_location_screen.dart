import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../widgets/error_snackbar.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({
    super.key,
  });

  static Future open(
    BuildContext context,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddLocationScreen(),
      ),
    );
  }

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  var addressLine1 = '';
  var addressLine2 = '';
  var pincode = '';
  var landmark = '';
  var city = 'Hyderabad';
  var country = 'India';
  var mobileNumber = '';

  @override
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Location"),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Enter your location details",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    addressLine1 = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Address Line 1*",
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the address line 1';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    addressLine2 = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Address Line 2",
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the address line 2';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    pincode = value;
                  });
                },
                decoration: const InputDecoration(hintText: "Pincode*"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter pincode';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    landmark = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Landmark",
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter landmark';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                onChanged: (value) {
                  setState(() {
                    city = value.toString();
                  });
                },
                decoration: const InputDecoration(hintText: "City"),
                items: const [
                  DropdownMenuItem(
                    value: "Agra",
                    child: Text("Agra"),
                  ),
                  DropdownMenuItem(
                    value: "Hyderabad",
                    child: Text("Hyderabad"),
                  ),
                  DropdownMenuItem(
                    value: "Delhi",
                    child: Text("Delhi"),
                  )
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                onChanged: (value) {
                  setState(() {
                    country = value.toString();
                  });
                },
                decoration: const InputDecoration(hintText: "Country"),
                items: const [
                  DropdownMenuItem(
                    value: "India",
                    child: Text("India"),
                  ),
                  DropdownMenuItem(
                    value: "USA",
                    child: Text("USA"),
                  ),
                  DropdownMenuItem(
                    value: "Dubai",
                    child: Text("Dubai"),
                  )
                ],
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    mobileNumber = value;
                  });
                },
                decoration: const InputDecoration(hintText: "Mobile Number*"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the mobile number';
                  } else if (value.length < 10) {
                    return 'Enter 10 digit mobile number';
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
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              ErrorSnackBar.show(
                context,
                "Fill Mandatory Fields to Continue",
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
            };
            print(body);
          },
          color: MyColors.primaryColor,
          child: const Text("Submit"),
        ),
      ),
    );
  }
}
