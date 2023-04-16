import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/clinician_details_widget.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/user_bloc.dart';
import '../../../../../../model/clinicians.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';

class SelectClinician extends StatefulWidget {
  final Function onTap;

  const SelectClinician({super.key, required this.onTap});

  @override
  State<SelectClinician> createState() => _SelectClinicianState();
}

class _SelectClinicianState extends State<SelectClinician> {
  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var sessionBloc = Provider.of<SessionBloc>(context, listen: true);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: FutureBuilder<List<Clinician>>(
        future: userBloc.getClinicians(query: {}),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }

          if (!snapshot.hasData) return const LoadingWidget();

          var clinicians = snapshot.data ?? [];

          if (clinicians.isEmpty) return const EmptyWidget();

          return ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 16),
                  hintText: 'Search',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: MyColors.divider),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: MyColors.primaryColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: clinicians.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) => CustomCard(
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
                                sessionBloc.selectedClinician =
                                    clinicians[index];
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
