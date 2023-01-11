import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  Avatar(
                    url:
                        'https://miro.medium.com/fit/c/88/88/1*0HhsaB_S9yiF-hi9AESZTg.jpeg',
                    name: 'Marshall Mathers',
                    borderRadius: BorderRadius.circular(20),
                    size: 70,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            TextFormField(
              onChanged: (value) {},
              decoration: InputDecoration(hintText: "Name"),
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 12),
            TextFormField(
              onChanged: (value) {},
              decoration: InputDecoration(hintText: "Number"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
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
              ],
            ),
            SizedBox(height: 12),
            TextFormField(
              onChanged: (value) {},
              decoration: const InputDecoration(hintText: "Age"),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 12),
            TextFormField(
              onChanged: (value) {},
              decoration: const InputDecoration(hintText: "Email Address*"),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ProgressButton(
          onPressed: () {},
          child: Text("Save Changes"),
        ),
      ),
    );
  }
}
