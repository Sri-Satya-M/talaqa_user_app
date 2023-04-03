import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/sesssion_bloc.dart';
import '../../../../../../utils/helper.dart';

class SelectSymptoms extends StatefulWidget {
  final List<String> symptoms;

  const SelectSymptoms({super.key, required this.symptoms});

  @override
  _SelectSymptomsState createState() => _SelectSymptomsState();
}

class _SelectSymptomsState extends State<SelectSymptoms> {
  @override
  Widget build(BuildContext context) {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: true);
    return DropdownButtonFormField(
      hint: const Text("Select a Type"),
      items: [
        for (String symptom in widget.symptoms)
          DropdownMenuItem<String>(
            value: symptom,
            child: Text(Helper.textCapitalization(text: symptom)),
          ),
      ],
      onChanged: (value) {
        sessionBloc.symptom = value;
        setState(() {});
      },
    );
  }
}
