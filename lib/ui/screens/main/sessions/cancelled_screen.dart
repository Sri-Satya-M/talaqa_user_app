import 'package:alsan_app/ui/screens/main/sessions/widgets/patient_card.dart';
import 'package:flutter/material.dart';

class CancelledScreen extends StatefulWidget {
  @override
  _CancelledScreenState createState() => _CancelledScreenState();
}

class _CancelledScreenState extends State<CancelledScreen> {
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
