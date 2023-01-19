import 'package:alsan_app/ui/screens/main/sessions/widgets/patient_card.dart';
import 'package:flutter/material.dart';

class CompletedScreen extends StatefulWidget {
  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: 2,
      itemBuilder: (context, index) {
        return PatientCard();
      },
    );
  }
}
