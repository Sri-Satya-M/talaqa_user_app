import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/mode_of_consultation.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../widgets/details_tile.dart';
import '../../../../../widgets/image_from_net.dart';

class SelectModeOfConsultation extends StatefulWidget {
  final List<ModeOfConsultation> consultations;
  final Function onTap;

  const SelectModeOfConsultation({
    super.key,
    required this.consultations,
    required this.onTap,
  });

  @override
  _SelectModeOfConsultationState createState() =>
      _SelectModeOfConsultationState();
}

class _SelectModeOfConsultationState extends State<SelectModeOfConsultation> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: true);
    return Column(
      children: [
        for (var mode in widget.consultations)
          Container(
            padding: const EdgeInsets.all(18),
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: const BoxDecoration(
              color: MyColors.paleLightBlue,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: DetailsTile(
              title: Row(
                children: [
                  ImageFromNet(imageUrl: mode.imageUrl, width: 12),
                  const SizedBox(width: 12),
                  Text(mode.title!, style: textTheme.bodyText1),
                  const Spacer(),
                  Radio(
                    value: mode.id,
                    groupValue: sessionBloc.selectedModeOfConsultation?.id,
                    onChanged: (value) {
                      setState(() {
                        sessionBloc.selectedModeOfConsultation = mode;
                        widget.onTap(mode);
                      });
                    },
                  )
                ],
              ),
              value: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: const BoxDecoration(
                  color: MyColors.lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text('${mode.price} Dirham', style: textTheme.bodyText2),
              ),
            ),
          ),
      ],
    );
  }
}
