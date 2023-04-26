import 'dart:io';

import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/profile.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/strings.dart';
import '../../../../../utils/helper.dart';
import '../../../../widgets/date_picker.dart';
import '../../../../widgets/image_picker.dart';

class EditPatientProfile extends StatefulWidget {
  final Profile profile;

  const EditPatientProfile({super.key, required this.profile});

  static Future open(BuildContext context, {required Profile profile}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPatientProfile(profile: profile),
      ),
    );
  }

  @override
  _EditPatientProfileState createState() => _EditPatientProfileState();
}

class _EditPatientProfileState extends State<EditPatientProfile> {
  final TextEditingController name = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  File? profileImage;

  @override
  void initState() {
    name.text = widget.profile.fullName ?? '';
    gender.text = widget.profile.gender ?? '';
    city.text = widget.profile.city ?? '';
    state.text = widget.profile.state ?? '';
    country.text = widget.profile.country ?? '';
    age.text = widget.profile.age?.toString() ?? '';
    dateCtrl.text = widget.profile.dob?.toString() ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(langBloc.getString(Strings.editPatientProfile)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                (profileImage == null)
                    ? Avatar(
                        url: widget.profile.image,
                        name: widget.profile.fullName,
                        borderRadius: BorderRadius.circular(20),
                        size: 90,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          profileImage!,
                          width: 90,
                          height: 90,
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      profileImage = await ImagePickerContainer.getImage(
                          context, ImageSource.gallery);
                      setState(() {});
                    },
                    child: const Icon(Icons.edit),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                hintText: "${langBloc.getString(Strings.name)}*",
              ),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return langBloc.getString(Strings.enterTheName);
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DatePicker(
              DateTime.now(),
              dateCtrl: dateCtrl,
              startDate: DateTime(1923),
              hintText: langBloc.getString(Strings.dateOfBirth),
              labelText: '',
              onDateChange: () {
                age.text = Helper.calculateAge(DateTime.parse(dateCtrl.text))
                    .toString();
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: age,
              decoration: InputDecoration(
                hintText: "${langBloc.getString(Strings.age)}*",
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return langBloc.getString(Strings.enterTheAge);
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: widget.profile.gender,
              onChanged: (value) {
                gender.text = value.toString();
              },
              decoration: InputDecoration(
                  hintText: "${langBloc.getString(Strings.selectGender)}*"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return langBloc.getString(Strings.enterTheGender);
                } else {
                  return null;
                }
              },
              items: [
                DropdownMenuItem(
                  value: "MALE",
                  child: Text("${langBloc.getString(Strings.male)}"),
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
            CSCPicker(
              layout: Layout.vertical,
              defaultCountry: CscCountry.United_Arab_Emirates,
              stateDropdownLabel: state.text,
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
                  country.text = value;
                });
              },
              onStateChanged: (value) {
                setState(() {
                  state.text = value.toString();
                });
              },
              onCityChanged: (value) {
                setState(() {
                  city.text = value.toString();
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 32,
        ),
        child: ProgressButton(
          onPressed: () async {
            var imageResponse = {};

            if (profileImage != null) {
              imageResponse = await userBloc.uploadFile(profileImage!.path);
            }
            var body = {
              "fullName": name.text,
              "age": int.tryParse(age.text),
              "city": city.text,
              "state": state.text,
              "country": country.text,
              "gender": gender.text,
              "dob": DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(dateCtrl.text)),
              if (profileImage != null) "image": imageResponse['key']
            };
            var response = await userBloc.updatePatients(
                id: widget.profile.id, body: body) as Map<String, dynamic>;
            if (!response.containsKey('status')) {
              return ErrorSnackBar.show(
                context,
                langBloc.getString(Strings.invalidError),
              );
            }

            Navigator.of(context).pop(true);
          },
          child: Text(langBloc.getString(Strings.saveChanges)),
        ),
      ),
    );
  }
}
