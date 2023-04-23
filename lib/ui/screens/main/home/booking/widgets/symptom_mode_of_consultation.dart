import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/select_symptom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/mode_of_consultation.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';
import 'select_mode_of_consultation.dart';

class SymptomModeOfConsultation extends StatefulWidget {
  final Function onTap;

  const SymptomModeOfConsultation({super.key, required this.onTap});

  @override
  _SymptomModeOfConsultationState createState() =>
      _SymptomModeOfConsultationState();
}

class _SymptomModeOfConsultationState extends State<SymptomModeOfConsultation> {
  @override
  Widget build(BuildContext context) {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ListView(
        children: [
          Text(langBloc.getString(Strings.symptoms)),
          const SizedBox(height: 16),
          FutureBuilder<List<String>>(
            future: sessionBloc.getPatientSymptoms(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return CustomErrorWidget(error: snapshot.error);
              }

              if (!snapshot.hasData) return const LoadingWidget();

              var symptoms = snapshot.data ?? [];

              if (symptoms.isEmpty) return const EmptyWidget();

              return SelectSymptoms(symptoms: symptoms);
            },
          ),
          const SizedBox(height: 32),
          Text(langBloc.getString(Strings.modeOfConsultation)),
          const SizedBox(height: 16),
          FutureBuilder<List<ModeOfConsultation>>(
            future: sessionBloc.getModeOfConsultation(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return CustomErrorWidget(error: snapshot.error);
              }

              if (!snapshot.hasData) return const LoadingWidget();

              var consultations = snapshot.data ?? [];

              if (consultations.isEmpty) return const EmptyWidget();

              return SelectModeOfConsultation(
                consultations: consultations,
                onTap: widget.onTap,
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
