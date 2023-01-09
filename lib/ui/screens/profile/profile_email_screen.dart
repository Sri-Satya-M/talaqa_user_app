import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/ui/widgets/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileEmailScreen extends StatefulWidget {
  const ProfileEmailScreen({super.key});

  @override
  _ProfileEmailScreenState createState() => _ProfileEmailScreenState();
}

class _ProfileEmailScreenState extends State<ProfileEmailScreen> {
  bool visibility = true;
  bool verify = false;
  bool numberEntered = false;
  final myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myController.addListener(() {
      setState(() {
        numberEntered = myController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                decoration: const InputDecoration(
                  labelText: "Name*",
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
                decoration: const InputDecoration(labelText: "Email Address*"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your email Id';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: "Select Gender"),
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text("Male"),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text("Female"),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text("Other"),
                  )
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: "Age*"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: "City"),
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text("Agra"),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text("Hyderabad"),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text("Delhi"),
                  )
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: "Country"),
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text("India"),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text("USA"),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text("China"),
                  )
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: visibility,
                decoration: InputDecoration(
                  labelText: "New Password*",
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: visibility,
                decoration: InputDecoration(
                  labelText: "Confirm Password*",
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                ],
              ),
              TextFormField(
                controller: myController,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  suffix: TextButton(
                    onPressed: numberEntered
                        ? () => setState(() {
                              verify = true;
                            })
                        : null,
                    child: const Text("Get OTP"),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              if (verify)
                TextFormField(
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: "Enter OTP",
                    suffix: TextButton(
                      onPressed: () {},
                      child: const Text("Resend"),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ProgressButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SuccessScreen(
                      message: "Profile Details has been \n Updated",
                      type: 'profile',
                      isEmailCheck: true)),
            );
          },
          color: MyColors.primaryColor,
          child: const Text("Submit"),
        ),
      ),
    );
  }
}
