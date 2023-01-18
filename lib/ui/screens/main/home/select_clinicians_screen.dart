import 'package:alsan_app/ui/screens/main/home/widgets/clinician_api_card.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class SelectClinicians extends StatefulWidget {
  @override
  _SelectCliniciansState createState() => _SelectCliniciansState();
}

class _SelectCliniciansState extends State<SelectClinicians> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Clinicians"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          CustomCard(
            child: TextFormField(
              style: textTheme.bodyText1?.copyWith(fontSize: 16),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                ),
                hintText: 'Search by clinician name',
                hintStyle: textTheme.caption?.copyWith(fontSize: 14),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 18),
          ClinicianAPiCard(scrollDirection: Axis.vertical)
        ],
      ),
    );
  }
}
