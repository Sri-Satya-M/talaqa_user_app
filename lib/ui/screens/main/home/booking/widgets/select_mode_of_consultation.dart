import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/sesssion_bloc.dart';
import '../../../../../../model/mode_of_consultation.dart';
import '../../../../../../utils/helper.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';

class SelectModeOfConsultation extends StatefulWidget {
  final Function onSelect;

  const SelectModeOfConsultation({super.key, required this.onSelect});

  @override
  _SelectModeOfConsultationState createState() =>
      _SelectModeOfConsultationState();
}

class _SelectModeOfConsultationState extends State<SelectModeOfConsultation> {
  int? modeId;

  @override
  Widget build(BuildContext context) {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: true);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return FutureBuilder<List<ModeOfConsultation>>(
      future: sessionBloc.getModeOfConsultation(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(error: snapshot.error);
        }

        if (!snapshot.hasData) return const LoadingWidget();

        var modes = snapshot.data ?? [];

        if (modes.isEmpty) return const EmptyWidget();

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: sessionBloc.selectedModeOfConsultation?.id,
              underline: null,
              isExpanded: true,
              hint: Text(langBloc.getString(Strings.selectAType)),
              items: [
                for (var mode in modes)
                  DropdownMenuItem<int>(
                    value: mode.id,
                    child: Text(Helper.textCapitalization(text: mode.type)),
                  ),
              ],
              onChanged: (value) {
                modeId = value;
                sessionBloc.selectedModeOfConsultation = modes.firstWhere(
                  (mode) => mode.id == modeId,
                );
                widget.onSelect.call(sessionBloc.selectedModeOfConsultation);
                setState(() {});
              },
            ),
          ),
        );
      },
    );
  }
}
