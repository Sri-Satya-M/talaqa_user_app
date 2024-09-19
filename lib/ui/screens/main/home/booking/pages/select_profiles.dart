import 'dart:io';

import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/ui/widgets/dialog_confirm.dart';
import 'package:alsan_app/ui/widgets/error_widget.dart';
import 'package:alsan_app/ui/widgets/pdf_viewer_screen.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/profile.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/images.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../utils/helper.dart';
import '../../../../../widgets/avatar.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_snackbar.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../../widgets/progress_button.dart';
import '../../../menu/profile/create_patient_screen.dart';

class SelectPatientProfile extends StatefulWidget {
  final Function(Profile) onTap;

  const SelectPatientProfile({super.key, required this.onTap});

  @override
  _SelectPatientProfileState createState() => _SelectPatientProfileState();
}

class _SelectPatientProfileState extends State<SelectPatientProfile> {
  int selectedIndex = -1;
  List<String> uploadKeys = [];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: true);
    var langBloc = Provider.of<LangBloc>(context, listen: false);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: FutureBuilder<List<Profile>>(
        future: userBloc.getPatients(id: userBloc.profile!.id.toString()),
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
                      color: MyColors.paleLightBlue,
                      border: Border.all(
                        color: selectedIndex == index
                            ? MyColors.primaryColor
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Avatar(
                              url: profiles[index].imageUrl,
                              name: profiles[index].fullName,
                              borderRadius: BorderRadius.circular(10),
                              size: 72,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(profiles[index].fullName ?? 'NA'),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${profiles[index].age?.toString()} ${langBloc.getString(Strings.years)}',
                                    style: textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${profiles[index].city ?? 'NA'}, ${profiles[index].state ?? 'NA'}, ${profiles[index].country ?? 'NA'}',
                                    style: textTheme.titleSmall!
                                        .copyWith(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    profiles[index].gender?.toCapitalized() ==
                                            'MALE'
                                        ? langBloc.getString(Strings.male)
                                        : profiles[index]
                                                    .gender
                                                    ?.toCapitalized() ==
                                                'FEMALE'
                                            ? langBloc.getString(Strings.female)
                                            : langBloc.getString(Strings.other),
                                    style: textTheme.titleSmall,
                                  ),
                                ),
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
                          ],
                        ),
                        if (index == selectedIndex) ...[
                          const SizedBox(height: 16),
                          for (var record
                              in profiles[index].medicalRecords ?? []) ...[
                            GestureDetector(
                              onTap: () => PdfViewerScreen.open(
                                context,
                                url: record.fileUrl!,
                              ),
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: MyColors.divider,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: MyColors.divider),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(Images.pdf, width: 24),
                                    const SizedBox(width: 16),
                                    Text(
                                      langBloc.getString(Strings.medicalRecord),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () async {
                                        var res = await ConfirmDialog.show(
                                          context,
                                          message:
                                              '${langBloc.getString(Strings.areYouSureYouWantToDelete)}?',
                                        );
                                        if (res == true) {
                                          await ProgressUtils.handleProgress(
                                              context, task: () async {
                                            await userBloc.removeMedicalRecord(
                                              id: record.id.toString(),
                                            );
                                            setState(() {});
                                          });
                                        }
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              maximumSize: const Size(double.maxFinite, 40),
                              minimumSize: const Size(double.maxFinite, 40),
                              side: const BorderSide(color: MyColors.divider),
                            ),
                            onPressed: () async {
                              await ProgressUtils.handleProgress(
                                context,
                                task: () async {
                                  List<File>? files = await Helper.pickFiles();
                                  uploadKeys = [];

                                  if (files == null) return;

                                  var filesFormData =
                                      await userBloc.uploadFiles(
                                    paths: files.map((f) => f.path).toList(),
                                    body: {},
                                  );

                                  int count = 0;

                                  for (var fileFormData in filesFormData) {
                                    var response =
                                        await userBloc.uploadMedicalRecords(
                                      body: fileFormData,
                                    ) as Map<String, dynamic>;

                                    if (response.containsKey('key')) {
                                      uploadKeys.add(response['key']);
                                      count++;
                                    }
                                  }

                                  if (count == filesFormData.length) {
                                    var result =
                                        await userBloc.saveMedicalRecords(
                                      body: {
                                        'patientProfileId': profiles[index].id!,
                                        'fileKeys': uploadKeys
                                      },
                                    ) as Map<String, dynamic>;
                                    ErrorSnackBar.show(
                                      context,
                                      langBloc.getString(
                                          Strings.filesUploadedSuccessfully),
                                    );

                                    setState(() {});
                                  }
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(Images.upload, width: 18),
                                const SizedBox(width: 16),
                                Text(
                                  langBloc.getString(
                                    Strings.uploadMedicalRecord,
                                  ),
                                  style: textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
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
                      Text(
                        langBloc.getString(Strings.addAPatient),
                        style: textTheme.bodySmall,
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
