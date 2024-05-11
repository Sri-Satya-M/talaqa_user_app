import 'dart:io';

import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/date_picker.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/ui/widgets/success_screen.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/local/shared_prefs.dart';
import '../../../resources/strings.dart';

class ProfileMobileScreen extends StatefulWidget {
  const ProfileMobileScreen({
    super.key,
  });

  static Future open(
    BuildContext context,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfileMobileScreen(),
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
  var city = '';
  var state = '';
  var country = '';
  var dateCtrl = TextEditingController();
  List<String> uploadKeys = [];
  FilePickerResult? pdfs;

  @override
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(langBloc.getString(Strings.profileDetails)),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                langBloc.getString(
                  Strings.enterYourDetailsToCompleteUserProfile,
                ),
                style: textTheme.displaySmall,
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
                  // FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.enterTheName);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                initialValue: userBloc.username,
                decoration: InputDecoration(
                    hintText: "${langBloc.getString(Strings.mobileNumber)}*"),
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
                  }
                  return null;
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
                readOnly: true,
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
                defaultCountry: CscCountry.Saudi_Arabia,
                disableCountry: true,
                showStates: true,
                showCities: true,
                flagState: CountryFlag.DISABLE,
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
                    state = value.toString();
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
                      : "${langBloc.getString(Strings.medicalRecords)}.pdf",
                  suffixIcon: const Icon(Icons.file_upload_outlined),
                ),
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
              'fullName': name,
              'type': 'MOBILE',
              "age": int.parse(age),
              'mobileNumber': userBloc.username,
              'countryCode': userBloc.countryCode,
              "dob": DateFormat('yyyy-MM-dd').format(
                DateTime.parse(dateCtrl.text),
              ),
              "city": city,
              "state": state,
              "country": country,
              "gender": gender,
              'language': langBloc.currentLanguageText == 'English'
                  ? '${langBloc.currentLanguageText}'.toUpperCase()
                  : 'ARABIC',
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

            if (uploadKeys.isNotEmpty) {
              await userBloc.saveMedicalRecords(
                body: {
                  'patientProfileId': userBloc.profile!.patientProfile!.id!,
                  'fileKeys': uploadKeys
                },
              );
            }

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
