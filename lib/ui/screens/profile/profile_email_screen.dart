import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/data/local/shared_prefs.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/ui/widgets/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  var country = '';
  var password = '';
  var confirmPassword = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Details")),
      body: Form(
        key: _formKey,
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
                  if (value == null || value.trim().isEmpty) {
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
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                onChanged: (value) {
                  setState(() {
                    gender = value.toString();
                  });
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
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    age = value;
                  });
                },
                decoration: const InputDecoration(hintText: "Age*"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ProgressButton(
          onPressed: () async {
            if (confirmPassword != password) {
              return ErrorSnackBar.show(context, "Password does not match");
            }
            var body = {
              "fullName": name,
              "type": "EMAIL",
              "age": int.parse(age),
              "city": city,
              "country": country,
              "gender": gender,
              "email": userBloc.username,
              "password": confirmPassword,
            };

            var response = await userBloc.patientSignUp(body: body)
                as Map<String, dynamic>;

            if (!response.containsKey('access_token')) {
              return ErrorSnackBar.show(context, "Invalid Error");
            }

            var token = response['access_token'];
            await Prefs.setToken(token);

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
