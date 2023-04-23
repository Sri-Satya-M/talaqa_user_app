import 'dart:io';

import 'package:alsan_app/bloc/language_bloc.dart';
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

import '../../../resources/strings.dart';
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
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.profileDetails))),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                langBloc.getString(Strings.enterProfileDetails),
                textAlign: TextAlign.center,
              ),
              Text(
                langBloc
                    .getString(Strings.enterYourDetailsToCompleteUserProfile),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "${langBloc.getString(Strings.name)}*",
                ),
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.enterTheName);
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: userBloc.username,
                enabled: false,
                decoration: InputDecoration(
                  hintText: "${langBloc.getString(Strings.emailAddress)}*",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.enterTheEmailId);
                  } else if (!value.contains("@") || !value.contains('.')) {
                    return langBloc.getString(Strings.enterValidEmailId);
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
                    return langBloc.getString(Strings.enterTheGender);
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: langBloc.getString(Strings.selectGender),
                ),
                items: [
                  DropdownMenuItem(
                    value: "MALE",
                    child: Text(langBloc.getString(Strings.male)),
                  ),
                  DropdownMenuItem(
                    value: "FEMALE",
                    child: Text(langBloc.getString(Strings.female)),
                  ),
                  DropdownMenuItem(
                    value: "OTHER",
                    child: Text(langBloc.getString(Strings.other)),
                  )
                ],
              ),
              const SizedBox(height: 8),
              DatePicker(
                DateTime.now(),
                dateCtrl: dateCtrl,
                startDate: DateTime(1923),
                hintText: langBloc.getString(Strings.dateOfBirth),
                labelText: '',
                onDateChange: () {
                  age = Helper.calculateAge(DateTime.parse(dateCtrl.text))
                      .toString();
                  setState(() {});
                },
              ),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: langBloc.getString(Strings.age),
                ),
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
                        langBloc.getString(Strings.filesUploadedSuccessfully),
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
                      ? langBloc.getString(Strings.uploadMedicalRecord)
                      : "${langBloc.getString(Strings.medicalRecord)}.pdf",
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
                  hintText: "${langBloc.getString(Strings.newPassword)}*",
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
                    return langBloc.getString(Strings.enterThePassword);
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
                  hintText: "${langBloc.getString(Strings.confirmPassword)}*",
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
                    return langBloc.getString(Strings.enterTheConfirmPassword);
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
                langBloc.getString(Strings.fillMandatoryFields),
              );
              return;
            }

            if (confirmPassword != password) {
              return ErrorSnackBar.show(
                context,
                langBloc.getString(Strings.passwordDoesNotMatch),
              );
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
              return ErrorSnackBar.show(
                context,
                langBloc.getString(Strings.invalidError),
              );
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
              message: langBloc.getString(
                Strings.profileDetailsUpdatedSuccessfully,
              ),
            );
          },
          color: MyColors.primaryColor,
          child: Text(langBloc.getString(Strings.submit)),
        ),
      ),
    );
  }
}
