import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/menu/profile/create_patient_screen.dart';
import 'package:alsan_app/ui/screens/main/menu/profile/edit_patient_profile.dart';
import 'package:alsan_app/ui/screens/main/menu/profile/patient_profile_screen.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/dialog_confirm.dart';
import 'package:alsan_app/ui/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/profile.dart';
import '../../../../../resources/strings.dart';
import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/loading_widget.dart';

class PatientProfiles extends StatefulWidget {
  final String id;

  const PatientProfiles({super.key, required this.id});

  @override
  _PatientProfilesState createState() => _PatientProfilesState();
}

class _PatientProfilesState extends State<PatientProfiles> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: true);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.patientDetails))),
      body: FutureBuilder<List<Profile>>(
        future: userBloc.getPatients(id: widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }
          if (!snapshot.hasData) return const LoadingWidget();

          var profiles = snapshot.data ?? [];

          if (profiles.isEmpty) return const EmptyWidget();

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: profiles.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: MyColors.paleLightBlue,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: InkWell(
                onTap: () => PatientDetailsScreen.open(
                  context,
                  id: profiles[index].id.toString(),
                ),
                child: Row(
                  children: [
                    Avatar(
                      url: profiles[index].imageUrl,
                      name: profiles[index].fullName,
                      borderRadius: BorderRadius.circular(10),
                      size: 100,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profiles[index].fullName ?? 'NA'),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                profiles[index].age?.toString() ?? 'NA',
                                style: textTheme.bodySmall,
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  profiles[index].gender ?? 'NA',
                                  style: textTheme.titleSmall,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${profiles[index].city ?? 'NA'},\n${profiles[index].state ?? 'NA'},\n${profiles[index].country ?? 'NA'}',
                            style: textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<int>(
                      onSelected: (int value) async {
                        switch (value) {
                          case 1:
                            var response = await EditPatientProfile.open(
                              context,
                              profile: profiles[index],
                            );
                            if (response) {
                              setState(() {});
                            }
                            break;
                          case 2:
                            bool? isConfirm = await ConfirmDialog.show(
                              context,
                              message: langBloc.getString(
                                Strings.confirmToRemoveTheProfile,
                              ),
                              title: langBloc.getString(Strings.deleteProfile),
                            );
                            if (isConfirm ?? false) {
                              var result = await userBloc.deletePatients(
                                profiles[index].id,
                              );
                              result ? profiles.removeAt(index) : null;
                              setState(() {});
                            }
                            break;
                        }
                      },
                      icon: const Icon(Icons.more_vert, color: Colors.black),
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text(langBloc.getString(Strings.edit)),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Text(langBloc.getString(Strings.remove)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var response = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePatient(),
            ),
          );
          if (response) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
