import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/error_widget.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/profile.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../menu/profile/create_patient_screen.dart';

class SelectPatientProfile extends StatefulWidget {
  final Function(Profile) onTap;

  const SelectPatientProfile({super.key, required this.onTap});

  @override
  _SelectPatientProfileState createState() => _SelectPatientProfileState();
}

class _SelectPatientProfileState extends State<SelectPatientProfile> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: true);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: FutureBuilder<List<Profile>>(
        future: userBloc.getPatients(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }
          if (!snapshot.hasData) return const LoadingWidget();

          var profiles = snapshot.data ?? [];

          if (profiles.isEmpty) return const EmptyWidget();

          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: profiles.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    selectedIndex = index;
                    widget.onTap(profiles[index]);
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1.5),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      children: [
                        Avatar(
                          url: profiles[index].image,
                          name: profiles[index].fullName,
                          borderRadius: BorderRadius.circular(10),
                          size: 72,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profiles[index].fullName ?? 'NA'),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  profiles[index].age?.toString() ?? 'NA',
                                  style: textTheme.caption,
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
                                  child: Text(profiles[index].gender ?? 'NA',
                                      style: textTheme.subtitle2),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  '${profiles[index].city ?? 'NA'}, ',
                                  style: textTheme.subtitle2,
                                ),
                                Text(
                                  profiles[index].country ?? 'NA',
                                  style: textTheme.subtitle2,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Radio(
                          value: index,
                          groupValue: selectedIndex,
                          onChanged: (value) {
                            selectedIndex = index;
                            widget.onTap(profiles[index]);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 80,
                decoration: DottedDecoration(
                  shape: Shape.box,
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () async {
                    var response = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreatePatient()),
                    );
                    if (response) {
                      setState(() {});
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, size: 20),
                      const SizedBox(width: 18),
                      Text('Add a Patient', style: textTheme.caption),
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
