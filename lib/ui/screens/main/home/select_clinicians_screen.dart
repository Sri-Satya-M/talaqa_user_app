import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:flutter/material.dart';

import 'booking/booking_screen.dart';
import 'widgets/clinician_list.dart';

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
        title: const Text("Clinicians"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          CustomCard(
            child: TextFormField(
              style: textTheme.bodyText1?.copyWith(fontSize: 16),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
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
          ClinicianList(
            scrollDirection: Axis.vertical,
            onTap: (clinician) {
              BookingScreen.open(context, clinician: clinician);
            },
          )
        ],
      ),
    );
  }
}
