import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePatient extends StatefulWidget {
  @override
  _CreatePatientState createState() => _CreatePatientState();
}

class _CreatePatientState extends State<CreatePatient> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Profile"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Text(
                "Create new patient profile",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 7),
              Text(
                "Enter patient details to create profile",
                textAlign: TextAlign.center,
                style: textTheme.bodyText1
                    ?.copyWith(color: Colors.black.withOpacity(0.7)),
              ),
              const SizedBox(height: 18),
              Center(
                child: Avatar(
                  url:
                      'https://miro.medium.com/fit/c/88/88/1*0HhsaB_S9yiF-hi9AESZTg.jpeg',
                  name: "ALex",
                  borderRadius: BorderRadius.circular(36),
                  size: 72,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {},
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
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                onChanged: (value) {},
                decoration: const InputDecoration(hintText: "Mobile Number*"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                onChanged: (value) {},
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
                ].toList (),
              ),
              const SizedBox(height: 12),
              TextFormField(
                onChanged: (value) {},
                decoration: const InputDecoration(hintText: "Age*"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                onChanged: (value) {},
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
              const SizedBox(height: 12),
              DropdownButtonFormField(
                onChanged: (value) {},
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
              SizedBox(height: 12),
              TextFormField(
                enabled: true,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "Upload medical record",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.upload),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "Medical history description",
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ProgressButton(
          onPressed: () {},
          color: MyColors.primaryColor,
          child: const Text("Create Profile"),
        ),
      ),
    );
  }
}
