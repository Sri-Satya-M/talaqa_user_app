import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/resources/strings.dart';
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
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: sessionBloc.symptom,
          underline: null,
          isExpanded: true,
          hint: Text(langBloc.getString(Strings.selectAType)),
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
        ),
      ),
    );
  }
}
