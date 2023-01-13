import 'package:alsan_app/ui/screens/main/menu/profile/create_patient_screen.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:flutter/material.dart';

class PatientProfile extends StatefulWidget {
  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Profiles"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            children: [
              Avatar(
                url:
                    'https://miro.medium.com/fit/c/88/88/1*0HhsaB_S9yiF-hi9AESZTg.jpeg',
                name: "ALex",
                borderRadius: BorderRadius.circular(10),
                size: 72,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ALex"),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "4 years",
                        style: textTheme.caption,
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text("Male", style: textTheme.subtitle2),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Dubai, UAE",
                    style: textTheme.subtitle2,
                  ),
                ],
              ),
              Spacer(
                flex: 1,
              ),
              PopupMenuButton<int>(
                onSelected: (int value) {
                  switch (value) {
                    case 1:
                      break;
                    case 2:
                      break;
                  }
                },
                icon: const Icon(Icons.more_vert, color: Colors.black),
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePatient(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
