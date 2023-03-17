import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/date_picker.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/ui/widgets/success_screen.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/local/shared_prefs.dart';

class ProfileMobileScreen extends StatefulWidget {
  const ProfileMobileScreen({
    super.key,
  });

  static Future open(
    BuildContext context,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileMobileScreen(),
      ),
    );
  }

  @override
  _ProfileMobileScreenState createState() => _ProfileMobileScreenState();
}

class _ProfileMobileScreenState extends State<ProfileMobileScreen> {
  var name = '';
  var gender = '';
  var age = '';
  var city = 'Hyderabad';
  var country = 'India';
  var dateCtrl = TextEditingController();

  @override
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Details"),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Text(
                "Enter Profile Details",
                textAlign: TextAlign.center,
              ),
              const Text(
                "Enter your details to complete user profile",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Name*",
                ),
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                enabled: false,
                initialValue: userBloc.username,
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
              const SizedBox(height: 8),
              DropdownButtonFormField(
                onChanged: (value) {
                  setState(() {
                    gender = value.toString();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the gender';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: "Select Gender"),
                items: const [
                  DropdownMenuItem(
                    value: "MALE",
                    child: Text("Male"),
                  ),
                  DropdownMenuItem(
                    value: "FEMALE",
                    child: Text("Female"),
                  ),
                  DropdownMenuItem(
                    value: "OTHER",
                    child: Text("Other"),
                  )
                ],
              ),
              DatePicker(
                DateTime.now(),
                dateCtrl: dateCtrl,
                startDate: DateTime(1923),
                hintText: 'Date Of Birth',
                labelText: '',
                onDateChange: () {
                  age = Helper.calculateAge(DateTime.parse(dateCtrl.text)).toString();
                },
              ),
              TextFormField(
                enabled: false,
                decoration: const InputDecoration(hintText: "Age"),
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text:
                      age.isEmpty ? '' : (age + (age == '1' ? ' yr' : ' yrs')),
                ),
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
                "Fill Mandatory Fields to Continue",
              );
              return null;
            }

            var body = {
              'fullName': name,
              'type': 'MOBILE',
              "age": int.parse(age),
              'mobileNumber': userBloc.username,
              "dob": DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(dateCtrl.text)),
              "city": city,
              "country": country,
              "gender": gender,
            };

            var response = await userBloc.patientSignUp(body: body)
                as Map<String, dynamic>;

            if (!response.containsKey('access_token')) {
              return ErrorSnackBar.show(context, "Invalid Error");
            }

            var token = response['access_token'];
            await Prefs.setToken(token);

            await userBloc.getProfile();

            SuccessScreen.open(
              context,
              type: 'MAIN',
              message: "Profile Details Updated Successfully",
            );
          },
          color: MyColors.primaryColor,
          child: const Text("Submit"),
        ),
      ),
    );
  }
}
