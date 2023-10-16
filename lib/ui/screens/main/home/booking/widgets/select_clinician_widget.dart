import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/ui/screens/main/home/clinician_details_screen.dart';
import 'package:alsan_app/ui/widgets/empty_widget.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/user_bloc.dart';
import '../../../../../../model/clinicians.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../widgets/custom_card.dart';
import '../../../../../widgets/loading_widget.dart';
import 'clinician_details_widget.dart';

class SelectClinicianWidget extends StatefulWidget {
  final Function onTap;
  final String search;
  final String serviceId;

  const SelectClinicianWidget({
    super.key,
    required this.onTap,
    required this.search,
    required this.serviceId,
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
        // 'date': Helper.formatDate(date: sessionBloc.selectedDate),
        // 'timeslotIds': sessionBloc.selectedTimeSlotIds!.join(','),
        // 'serviceId': sessionBloc.service!.id!,
        // 'modeId': sessionBloc.selectedModeOfConsultation!.id!
      };

      if (widget.search.isNotEmpty) {
        query['search'] = widget.search;
      }

      if (widget.serviceId == 'null' || widget.serviceId == '') {
        return ErrorSnackBar.show(
          context,
          'Please select the service in previous steps',
        );
      }

      var list = await context.read<UserBloc>().getCliniciansByService(
            serviceId: widget.serviceId,
            query: query,
          );

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
    return (isFinished && clinicians.isEmpty)
        ? const EmptyWidget(message: 'Clinicians Not available')
        : ListView.builder(
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
                      child: InkWell(
                        onTap: () {
                          ClinicianDetailsScreen.open(
                            context,
                            clinician: clinicians[index],
                          );
                        },
                        child: ClinicianDetailsWidget(
                          clinician: clinicians[index],
                        ),
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
