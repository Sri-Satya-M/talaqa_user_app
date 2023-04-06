import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../../../../../resources/colors.dart';
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.cementShade2,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Consultation Bill Details', style: textTheme.bodyText1),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Consultation fee ($noOfTimeslots ${Helper.textCapitalization(text: consultationMode)} Slot${noOfTimeslots > 1 ? 's' : ''})',
                ),
              ),
              Text('$totalAmount Dihram'),
            ],
          ),
          const SizedBox(height: 12),
          const DottedLine(dashGapLength: 4, dashColor: MyColors.divider),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Total Amount'),
              const Spacer(),
              Text('$totalAmount Dirham'),
            ],
          ),
        ],
      ),
    );
  }
}
