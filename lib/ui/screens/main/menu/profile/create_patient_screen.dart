import 'dart:io';

import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../resources/strings.dart';
import '../../../../../utils/helper.dart';
import '../../../../widgets/date_picker.dart';
import '../../../../widgets/image_picker.dart';

class CreatePatient extends StatefulWidget {
  @override
  _CreatePatientState createState() => _CreatePatientState();
}

class _CreatePatientState extends State<CreatePatient> {
  String? name;
  var age = '';
  String? city;
  String? country;
  String? state;
  String? gender;
  File? profileImage;
  String relation = '';
  var dateCtrl = TextEditingController();
  List<String> uploadKeys = [];

  final formKey = GlobalKey<FormState>();
  FilePickerResult? pdfs;

  String getNames(List<String?>? names) {
    String ns = "";
    for (name in names!) {
      ns += "$name,";
    }
    return ns;
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.patientProfile))),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                langBloc.getString(Strings.createNewPatientProfile),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 7),
              Text(
                langBloc.getString(Strings.enterPatientDetailsToCreateProfile),
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge
                    ?.copyWith(color: Colors.black.withOpacity(0.7)),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      (profileImage == null)
                          ? Avatar(
                              url: "widget.profile.image",
                              name: "@",
                              borderRadius: BorderRadius.circular(20),
                              size: 90,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                profileImage!,
                                width: 90,
                                height: 90,
                              )),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            profileImage = await ImagePickerContainer.getImage(
                              context,
                              ImageSource.gallery,
                            );
                            setState(() {});
                          },
                          child: const Icon(Icons.edit),
                        ),
                      )
                    ],
                  ),
                ],
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
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${langBloc.getString(Strings.enterTheName)}';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // TextFormField(
              //   onChanged: null,
              //   decoration: const InputDecoration(
              //     hintText: "Mobile Number",
              //     counter: SizedBox.shrink(),
              //   ),
              //   keyboardType: TextInputType.number,
              //   maxLength: 10,
              //   validator: (value) {
              //     if (value == null || value.trim().isEmpty) {
              //       return "Enter the mobile number";
              //     } else if (value.length < 10) {
              //       return "Enter 10 digit mobile number";
              //     }
              //   },
              // ),
              DropdownButtonFormField(
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "${langBloc.getString(Strings.selectGender)}*",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "${langBloc.getString(Strings.selectGender)}";
                  } else {
                    return null;
                  }
                },
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
                ].toList(),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: langBloc.getString(Strings.age),
                  filled: false,
                ),
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text:
                      age.isEmpty ? '' : (age + (age == '1' ? ' yr' : ' yrs')),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return langBloc.getString(Strings.enterTheAge);
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    relation = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "${langBloc.getString(Strings.relation)}*",
                ),
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CSCPicker(
                layout: Layout.vertical,
                defaultCountry: CscCountry.Saudi_Arabia,
                flagState: CountryFlag.DISABLE,
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
                    state = value.toString();
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    city = value.toString();
                  });
                },
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
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
            var imageResponse = {};

            if (profileImage != null) {
              imageResponse = await userBloc.uploadFile(profileImage!.path);
            }
            var body = {
              "fullName": name,
              "age": int.parse(age),
              "city": city,
              "state": state,
              "country": country,
              "gender": gender,
              "relation": relation,
              "dob": DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(dateCtrl.text)),
              if (profileImage != null) "image": imageResponse['key']
            };

            var response = await userBloc.createPatient(body: body);

            if (response.id == null) {
              return ErrorSnackBar.show(
                context,
                langBloc.getString(Strings.invalidError),
              );
            }

            var result = await userBloc.saveMedicalRecords(
              body: {'patientProfileId': response.id, 'fileKeys': uploadKeys},
            ) as Map<String, dynamic>;

            if (result.containsKey('status') && result['status'] == 'success') {
              Navigator.of(context).pop(true);
            }
          },
          color: MyColors.primaryColor,
          child: Text(langBloc.getString(Strings.createProfile)),
        ),
      ),
    );
  }
}
