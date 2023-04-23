import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/date_picker.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../resources/strings.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? name;
  String? gender;
  String? city;
  String? dob;
  int? age;
  var dateCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var profile = userBloc.profile;
    name = profile!.user!.fullName!;
    gender = profile.gender!;
    age = profile.age;
    city = profile.city!;
    dob = profile.dob!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.editProfile))),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    Avatar(
                      url: userBloc.profile?.image,
                      name: userBloc.profile?.user?.fullName,
                      borderRadius: BorderRadius.circular(20),
                      size: 70,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: name,
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(
                  hintText: langBloc.getString(Strings.name),
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.enterTheName);
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 12),
              DatePicker(
                DateTime.parse(dob!),
                dateCtrl: dateCtrl,
                onDateChange: () {},
              ),
              const SizedBox(height: 12),
              TextFormField(
                enabled: false,
                initialValue: userBloc.profile?.user?.mobileNumber,
                onChanged: (value) {},
                decoration: const InputDecoration(
                  hintText: "Number",
                  counter: SizedBox(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.enterTheMobileNumber);
                  } else if (value.length < 10) {
                    return langBloc.getString(Strings.enter10DigitMobileNumber);
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: gender,
                onChanged: (value) {
                  gender = value.toString();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.gender);
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
              const SizedBox(height: 12),
              TextFormField(
                initialValue: age.toString(),
                onChanged: (value) {
                  age = int.tryParse(value.trim());
                },
                decoration: InputDecoration(
                  hintText: langBloc.getString(Strings.age),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.enterTheAge);
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: userBloc.profile?.user?.email,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: langBloc.getString(Strings.emailAddress),
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
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: city,
                onChanged: (value) {
                  city = value.toString();
                },
                decoration: InputDecoration(
                  hintText: langBloc.getString(Strings.city),),
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
                  langBloc.getString(Strings.fillMandatoryFields)
              );
              return;
            }

            var body = {
              "city": city,
              // "image": image,
              "fullName": name,
              "age": age,
              "gender": gender,
            };

            await userBloc.updateProfile(body: body);
            Navigator.pop(context);
          },
          child: const Text("Save Changes"),
        ),
      ),
    );
  }
}
