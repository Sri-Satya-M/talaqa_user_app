import 'dart:io';

import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/date_picker.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../model/profile.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/strings.dart';
import '../../../../../utils/helper.dart';
import '../../../../widgets/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();

  static Future open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? gender;
  Profile? profile;
  final TextEditingController email = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  File? profileImage;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    profile = userBloc.profile;
    gender = profile!.gender!.toUpperCase();
    age.text = profile!.age.toString();
    email.text = profile?.user?.email ?? '';
    mobile.text = profile?.user?.mobileNumber ?? '';
    dateCtrl.text = profile!.dob?.toString() ?? '';
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
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            profileImage = await ImagePickerContainer.getImage(
                              context,
                              ImageSource.gallery,
                            );
                            setState(() {});
                          },
                          child: (profileImage == null)
                              ? Avatar(
                                  url: userBloc.profile?.imageUrl,
                                  name: userBloc.profile?.user?.fullName,
                                  borderRadius: BorderRadius.circular(20),
                                  size: 90,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    profileImage!,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(Icons.edit, color: MyColors.primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: userBloc.profile!.user!.fullName!,
                enabled: false,
                decoration: InputDecoration(
                  labelText: langBloc.getString(Strings.name),
                  contentPadding: const EdgeInsets.only(left: 16),
                  hintText: langBloc.getString(Strings.name),
                  fillColor: MyColors.divider,
                  filled: true,
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: mobile,
                keyboardType: Platform.isIOS
                    ? const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: false,
                      )
                    : TextInputType.number,
                onSaved: (text) {
                  mobile.text = text?.trim() ?? '';
                },
                decoration: InputDecoration(
                  labelText: langBloc.getString(Strings.mobileNumber),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              TextFormField(
                controller: email,
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
              DatePicker(
                DateTime.parse(dateCtrl.text),
                dateCtrl: dateCtrl,
                labelText: 'DOB',
                onDateChange: () {
                  age.text = Helper.calculateAge(
                    DateTime.parse(dateCtrl.text),
                  ).toString();
                  setState(() {});
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: age,
                enabled: false,
                decoration: InputDecoration(
                  labelText: langBloc.getString(Strings.age),
                  contentPadding: const EdgeInsets.only(left: 16),
                  fillColor: MyColors.divider,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return langBloc.getString(Strings.enterTheAge);
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: gender,
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
                    return langBloc.getString(Strings.selectGender);
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: ProgressButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) {
              return ErrorSnackBar.show(
                context,
                langBloc.getString(Strings.fillMandatoryFields),
              );
            }

            var imageResponse = {};

            if (profileImage != null) {
              imageResponse = await userBloc.uploadFile(profileImage!.path);
            }

            var body = {
              "dob": DateFormat('yyyy-MM-dd').format(
                DateTime.parse(dateCtrl.text),
              ),
              "age": int.tryParse(age.text),
              if (profile?.user?.email != email.text) "email": email.text,
              if (profile?.gender != email.text) "gender": gender,
              if (profileImage != null) "imageUrl": imageResponse['key']
            };

            if (profile?.user?.mobileNumber != mobile.text) {
              body["mobileNumber"] = mobile.text;
            }

            await userBloc.updateProfile(body: body);
            await userBloc.getProfile();

            ErrorSnackBar.show(context, 'Profile Updated Successfully');
            Navigator.pop(context, true);
          },
          child: const Text("Save Changes"),
        ),
      ),
    );
  }
}
