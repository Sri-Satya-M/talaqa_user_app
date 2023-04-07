import 'package:alsan_app/ui/screens/main/home/booking/booking_screen.dart';
import 'package:alsan_app/ui/screens/main/home/widgets/clinician_list.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class BrowseScreen extends StatefulWidget {
  @override
  _BrowseScreenState createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomCard(
            child: TextFormField(
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                ),
                hintText: 'Search by clinician name',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Top Rated Clinicians",
            style: textTheme.subtitle2,
          ),
          const SizedBox(height: 12),
          ClinicianList(
            scrollDirection: Axis.vertical,
            onTap: (clinician) {
              BookingScreen.open(context, clinician: clinician);
            },
          ),
        ],
      ),
    );
  }
}
