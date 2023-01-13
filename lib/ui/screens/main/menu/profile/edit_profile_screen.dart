import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? name;

  String? gender;
  String? city;
  int? age;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var profile = userBloc.profile;
    name = profile!.user!.fullName!;
    gender = profile.gender!;
    age = profile.age;
    city = profile.city!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
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
              SizedBox(height: 24),
              TextFormField(
                initialValue: name,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(hintText: "Name"),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the name";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                enabled: false,
                initialValue: userBloc.profile?.user?.mobileNumber,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "Number",
                  counter: SizedBox(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the mobile number";
                  } else if (value.length < 10) {
                    return "Enter 10 digit number";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 12),
              DropdownButtonFormField(
                value: gender,
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
              SizedBox(height: 12),
              TextFormField(
                initialValue: age.toString(),
                onChanged: (value) {
                  setState(() {
                    age = int.tryParse(value.trim());
                  });
                },
                decoration: const InputDecoration(hintText: "Age"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the age";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                initialValue: userBloc.profile?.user?.email,
                onChanged: (value) {},
                decoration: const InputDecoration(hintText: "Email Address"),
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
              SizedBox(height: 12),
              DropdownButtonFormField(
                value: city,
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ProgressButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) {
              ErrorSnackBar.show(
                context,
                'Fill Mandatory Fields to Continue',
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
          child: Text("Save Changes"),
        ),
      ),
    );
  }
}
