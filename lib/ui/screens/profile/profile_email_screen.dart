import 'dart:io';

import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/data/local/shared_prefs.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/ui/widgets/success_screen.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/helper.dart';
import '../../widgets/date_picker.dart';

class ProfileEmailScreen extends StatefulWidget {
  const ProfileEmailScreen({super.key});

  static Future open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileEmailScreen(),
      ),
    );
  }

  @override
  _ProfileEmailScreenState createState() => _ProfileEmailScreenState();
}

class _ProfileEmailScreenState extends State<ProfileEmailScreen> {
  bool visibility = true;
  bool visibility2 = true;
  var name = '';
  var gender = '';
  var age = '';
  var city = '';
  var state = '';
  var country = '';
  var password = '';
  var confirmPassword = '';
  var dateCtrl = TextEditingController();
  List<String> uploadKeys = [];
  FilePickerResult? pdfs;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Details")),
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
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: userBloc.username,
                enabled: false,
                decoration: const InputDecoration(hintText: "Email Address*"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the email Id";
                  } else if (!value.contains("@") || !value.contains('.')) {
                    return "Enter valid email id";
                  } else {
                    return null;
                  }
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
                    return "Enter the gender";
                  } else {
                    return null;
                  }
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
              const SizedBox(height: 8),
              DatePicker(
                DateTime.now(),
                dateCtrl: dateCtrl,
                startDate: DateTime(1923),
                hintText: 'Date Of Birth',
                labelText: '',
                onDateChange: () {
                  age = Helper.calculateAge(DateTime.parse(dateCtrl.text))
                      .toString();
                  setState(() {});
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
              const SizedBox(height: 16),
              CSCPicker(
                layout: Layout.vertical,
                defaultCountry: CscCountry.United_Arab_Emirates,
                disableCountry: true,
                showStates: true,
                showCities: true,
                dropdownDecoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: MyColors.divider),
                  borderRadius: BorderRadius.circular(5),
                ),
                onCountryChanged: (value) {
                  setState(() {
                    country = value;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    // stateValue = value;
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    city = value.toString();
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                enabled: uploadKeys.isEmpty,
                onTap: () async {
                  List<File>? files = await Helper.pickFiles();

                  if (files == null) return;

                  var filesFormData = await userBloc.uploadFiles(
                    paths: files.map((f) => f.path).toList(),
                    body: {},
                  );

                  int count = 0;

                  for (var fileFormData in filesFormData) {
                    var response = await userBloc.uploadMedicalRecords(
                      body: fileFormData,
                    ) as Map<String, dynamic>;

                    if (response.containsKey('key')) {
                      uploadKeys.add(response['key']);
                      count++;
                    }

                    if (count == filesFormData.length) {
                      ErrorSnackBar.show(
                        context,
                        'Files Uploaded Successfully',
                      );
                    }
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: uploadKeys.isEmpty
                      ? null
                      : const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Icon(Icons.picture_as_pdf),
                        ),
                  hintText: uploadKeys.isEmpty
                      ? "Upload Medical Record"
                      : "Medical Records.pdf",
                  suffixIcon: const Icon(Icons.file_upload_outlined),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    password = value.toString();
                  });
                },
                obscureText: visibility,
                decoration: InputDecoration(
                  hintText: "New Password*",
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      visibility = !visibility;
                    }),
                    icon: Icon(
                      visibility ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter the password";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value.toString();
                  });
                },
                obscureText: visibility2,
                decoration: InputDecoration(
                  hintText: "Confirm Password*",
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      visibility2 = !visibility2;
                    }),
                    icon: Icon(
                      visibility2 ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter the confirm password";
                  } else {
                    return null;
                  }
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
                "Fill Mandatory Fields to Continue",
              );
              return;
            }

            if (confirmPassword != password) {
              return ErrorSnackBar.show(context, "Password does not match");
            }

            var body = {
              "fullName": name,
              "type": "EMAIL",
              "age": int.parse(age),
              "email": userBloc.username,
              "password": confirmPassword,
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

            await userBloc.saveMedicalRecords(
              body: {
                'patientProfileId': userBloc.profile!.patientProfile!.id!,
                'fileKeys': uploadKeys
              },
            ) as Map<String, dynamic>;

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
