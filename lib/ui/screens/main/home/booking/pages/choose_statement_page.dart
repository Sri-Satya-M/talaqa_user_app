import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/session_bloc.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../widgets/select_symptom.dart';

class ChooseStatementPage extends StatefulWidget {
  const ChooseStatementPage({super.key});

  @override
  _ChooseStatementPageState createState() => _ChooseStatementPageState();
}

class _ChooseStatementPageState extends State<ChooseStatementPage> {
  List<String> symptoms = [];

  @override
  void initState() {
    super.initState();
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    sessionBloc.selectedStatement = -1;
    sessionBloc.symptom = null;
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    if (langBloc.currentLanguageText == 'English') {
      symptoms =
          sessionBloc.service?.symptoms?.map((e) => e.title ?? '').toList() ??
              [];
    } else {
      symptoms =
          sessionBloc.service?.symptoms?.map((e) => e.arabic ?? '').toList() ??
              [];
    }
    print('index ${sessionBloc.selectedStatement}');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: [
          Container(
            height: 90,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: MyColors.seaBlue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Text(
                    "I know what i have, I've been diagnosed before",
                    style: textTheme.displaySmall,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Radio(
                    value: sessionBloc.selectedStatement,
                    groupValue: 1,
                    onChanged: (value) {
                      sessionBloc.selectedStatement = 1;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: MyColors.seaBlue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Text(
                    "I don't know what I might have",
                    style: textTheme.displaySmall,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Radio(
                    value: 2,
                    groupValue: sessionBloc.selectedStatement,
                    onChanged: (value) {
                      sessionBloc.selectedStatement = 2;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          if (sessionBloc.selectedStatement == 1) ...[
            const SizedBox(height: 16),
            Text(langBloc.getString(Strings.symptoms)),
            const SizedBox(height: 16),
            SelectSymptoms(symptoms: symptoms),
          ]
        ],
      ),
    );
  }
}
