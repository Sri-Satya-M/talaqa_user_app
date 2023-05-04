import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/user_bloc.dart';
import '../../../../../../model/clinicians.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../utils/helper.dart';
import '../../../../../widgets/custom_card.dart';
import '../../../../../widgets/loading_widget.dart';
import 'clinician_details_widget.dart';

class SelectClinicianWidget extends StatefulWidget {
  final Function onTap;
  final String search;

  const SelectClinicianWidget({
    super.key,
    required this.onTap,
    required this.search,
  });

  @override
  _SelectClinicianWidgetState createState() => _SelectClinicianWidgetState();
}

class _SelectClinicianWidgetState extends State<SelectClinicianWidget> {
  bool state = false;

  bool isFinished = false;
  bool isLoading = false;
  List<Clinician> clinicians = [];

  Future<void> fetchMore() async {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    if (isFinished || isLoading) return;
    isLoading = true;
    try {
      var limit = 20;
      var query = {
        'offset': clinicians.length.toString(),
        'limit': limit.toString(),
        'date': Helper.formatDate(date: sessionBloc.selectedDate),
        'timeslotIds': sessionBloc.selectedTimeSlotIds!.join(','),
      };

      if (widget.search.isNotEmpty) {
        query['search'] = widget.search;
      }

      var list = await context.read<UserBloc>().getAvailableClinicians(query: query);
      clinicians.addAll(list);

      if (list.length < limit) isFinished = true;
    } catch (e) {
      isFinished = true;
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: clinicians.length + ((isFinished) ? 0 : 1),
      padding: EdgeInsets.zero,
      physics: const ScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        if (index == clinicians.length) {
          fetchMore();
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const LoadingWidget(),
                  const SizedBox(height: 8),
                  Text(
                    'Fetching more Clinicians',
                    style: textTheme.caption!.copyWith(
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          );
        }

        return CustomCard(
          radius: 5,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: (sessionBloc.selectedClinician?.id ==
                            clinicians[index].id)
                        ? MyColors.primaryColor
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ClinicianDetailsWidget(
                  clinician: clinicians[index],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 64),
                    Radio(
                      value: clinicians[index].id,
                      groupValue: sessionBloc.selectedClinician?.id,
                      onChanged: (value) {
                        sessionBloc.selectedClinician = clinicians[index];
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
