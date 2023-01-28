import 'package:flutter/material.dart';

import '../../widgets/clinician_list.dart';

class SelectClinician extends StatelessWidget {
  final Function onTap;

  const SelectClinician({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: ClinicianList(
        scrollDirection: Axis.vertical,
        onTap: onTap,
      ),
    );
  }
}
