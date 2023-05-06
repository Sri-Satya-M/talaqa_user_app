import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../utils/helper.dart';

class BillDetailsWidget extends StatelessWidget {
  final int noOfTimeslots;
  final double totalAmount;
  final String consultationMode;

  const BillDetailsWidget({
    super.key,
    required this.noOfTimeslots,
    required this.totalAmount,
    required this.consultationMode,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.cementShade2,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            langBloc.getString(Strings.consultationBillDetails),
            style: textTheme.bodyText1,
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${langBloc.getString(Strings.consultationFee)}\n($noOfTimeslots ${Helper.textCapitalization(text: consultationMode)} Slot${noOfTimeslots > 1 ? 's' : ''})',
                ),
              ),
              const SizedBox(width: 32),
              Text('$totalAmount ${langBloc.getString(Strings.dirham)}'),
            ],
          ),
          const SizedBox(height: 12),
          const DottedLine(dashGapLength: 4, dashColor: MyColors.divider),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(langBloc.getString(Strings.totalAmount)),
              const Spacer(),
              Text('$totalAmount ${langBloc.getString(Strings.dirham)}'),
            ],
          ),
        ],
      ),
    );
  }
}
