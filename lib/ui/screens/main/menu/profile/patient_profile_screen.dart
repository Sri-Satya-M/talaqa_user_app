import 'dart:io';

import 'package:alsan_app/model/medical_records.dart';
import 'package:alsan_app/ui/widgets/dialog_confirm.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/user_bloc.dart';
import '../../../../../model/profile.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/images.dart';
import '../../../../../utils/helper.dart';
import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../../../../widgets/pdf_viewer_screen.dart';
import '../../home/booking/widgets/patient_details_widget.dart';
import 'widget/patient_profile_dashboard.dart';

class PatientDetailsScreen extends StatefulWidget {
  final String id;

  const PatientDetailsScreen({super.key, required this.id});

  static Future open(BuildContext context, {required String id}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PatientDetailsScreen(id: id),
      ),
    );
  }

  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Patient Details')),
      body: FutureBuilder<Profile>(
          future: userBloc.getPatientProfile(id: widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return CustomErrorWidget(error: snapshot.error);
            }

            if (!snapshot.hasData) return const LoadingWidget();

            var profile = snapshot?.data;

            if (profile == null) return const EmptyWidget();

            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: const BoxDecoration(
                    color: MyColors.paleLightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      PatientDetailsWidget(patient: profile),
                      Container(
                        margin: const EdgeInsets.all(16),
                        child: InkWell(
                          onTap: () async {
                            ProgressUtils.handleProgress(
                              context,
                              task: () async {
                                List<File>? files = await Helper.pickFiles();

                                if (files == null) return;

                                var filesFormData = await userBloc.uploadFiles(
                                  paths: files.map((f) => f.path).toList(),
                                  body: {},
                                );

                                int count = 0;
                                List<String> uploadKeys = [];

                                for (var fileFormData in filesFormData) {
                                  var response =
                                      await userBloc.uploadMedicalRecords(
                                    body: fileFormData,
                                  ) as Map<String, dynamic>;

                                  if (response.containsKey('key')) {
                                    uploadKeys.add(response['key']);
                                    count++;
                                  }

                                  if (count == filesFormData.length) {
                                    var result =
                                        await userBloc.saveMedicalRecords(
                                      body: {
                                        'patientProfileId': profile.id,
                                        'fileKeys': uploadKeys
                                      },
                                    ) as Map<String, dynamic>;

                                    if (result.containsKey('status') &&
                                        result['status'] == 'success') {
                                      ErrorSnackBar.show(
                                        context,
                                        'Files Uploaded Successfully',
                                      );
                                      setState(() {});
                                    }
                                  }
                                }
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Image.asset(Images.pdf, height: 25),
                              const SizedBox(width: 16),
                              const Text('Upload Medical Report'),
                              const Spacer(),
                              const Icon(
                                Icons.file_upload_outlined,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Medical Reports',
                      style: textTheme.subtitle2,
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<List<MedicalRecord>>(
                      future: userBloc.getMedicalRecords(
                        query: {'patientProfileId': profile.id},
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return CustomErrorWidget(error: snapshot.error);
                        }

                        if (!snapshot.hasData) return const LoadingWidget();

                        var medicalRecords = snapshot.data ?? [];

                        if (medicalRecords.isEmpty) {
                          return SizedBox(
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No Medical Records on this Patient',
                                  style: textTheme.caption,
                                ),
                              ],
                            ),
                          );
                        };

                        return ListView.separated(
                          itemCount: medicalRecords.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                PdfViewerScreen.open(
                                  context,
                                  url: medicalRecords[index].fileUrl!,
                                );
                              },
                              child: Row(
                                children: [
                                  Image.asset(Images.pdf, height: 25),
                                  const SizedBox(width: 16),
                                  Text('Medical Report ${index + 1}'),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () async {
                                      bool? confirm = await ConfirmDialog.show(
                                        context,
                                        message: 'Confirm to delete record',
                                        title: 'Medical Report ${index + 1}',
                                      );
                                      if (confirm ?? false) {
                                        var res =
                                            await userBloc.removeMedicalRecord(
                                          id: medicalRecords[index]
                                              .id
                                              .toString(),
                                        ) as Map<String, dynamic>;
                                        if (res.containsKey('status') &&
                                            res['status'] == 'success') {
                                          ErrorSnackBar.show(
                                              context, res['message']);
                                          setState(() {});
                                        }
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PatientProfileDashboard(
                  patientProfileId: profile.id.toString(),
                ),
              ],
            );
          }),
    );
  }
}
