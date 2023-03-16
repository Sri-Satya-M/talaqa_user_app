import 'dart:io';

import 'package:alsan_app/model/medical_records.dart';
import 'package:alsan_app/ui/widgets/dialog_confirm.dart';
import 'package:alsan_app/ui/widgets/dynamic_grid_view.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/user_bloc.dart';
import '../../../../../model/profile.dart';
import '../../../../../resources/images.dart';
import '../../../../../utils/helper.dart';
import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../../../../widgets/pdf_viewer_screen.dart';
import '../../home/booking/widgets/patient_details_widget.dart';
import 'widget/session_overview_card.dart';

class PatientDetailsScreen extends StatefulWidget {
  final Profile patient;

  const PatientDetailsScreen({super.key, required this.patient});

  static Future open(BuildContext context, {required Profile patient}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PatientDetailsScreen(patient: patient),
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
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        children: [
          PatientDetailsWidget(patient: widget.patient),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
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
                      var response = await userBloc.uploadMedicalRecords(
                        body: fileFormData,
                      ) as Map<String, dynamic>;

                      if (response.containsKey('key')) {
                        uploadKeys.add(response['key']);
                        count++;
                      }

                      if (count == filesFormData.length) {
                        var result = await userBloc.saveMedicalRecords(
                          body: {
                            'patientProfileId': widget.patient.id,
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
                  Image.asset(Images.pdf, height: 40),
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
          const SizedBox(height: 16),
          const Text('Session Analytics'),
          const SizedBox(height: 16),
          Text(
            'Session Details',
            style: textTheme.caption,
          ),
          const SizedBox(height: 8),
          const DynamicGridView(
            spacing: 0,
            count: 2,
            children: [
              SessionOverviewCard(),
              SessionOverviewCard(),
              SessionOverviewCard(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Mode of Consultation',
            style: textTheme.caption,
          ),
          const SizedBox(height: 8),
          const DynamicGridView(
            spacing: 0,
            count: 2,
            children: [
              SessionOverviewCard(),
              SessionOverviewCard(),
              SessionOverviewCard(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Session Information',
            style: textTheme.caption,
          ),
          const SizedBox(height: 8),
          const DynamicGridView(
            spacing: 0,
            count: 2,
            children: [
              SessionOverviewCard(),
              SessionOverviewCard(),
              SessionOverviewCard(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Medical Reports',
            style: textTheme.caption,
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<MedicalRecord>>(
            future: userBloc.getMedicalRecords(
              query: {'patientProfileId': widget.patient.id},
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return CustomErrorWidget(error: snapshot.error);
              }

              if (!snapshot.hasData) return const LoadingWidget();

              var medicalRecords = snapshot.data ?? [];

              if (medicalRecords.isEmpty) return const EmptyWidget();

              return ListView.builder(
                itemCount: medicalRecords.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      onTap: () {
                        PdfViewerScreen.open(
                          context,
                          url: medicalRecords[index].fileUrl!,
                        );
                      },
                      child: Row(
                        children: [
                          Image.asset(Images.pdf, height: 40),
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
                                var res = await userBloc.removeMedicalRecord(
                                  id: medicalRecords[index].id.toString(),
                                ) as Map<String, dynamic>;
                                if (res.containsKey('status') &&
                                    res['status'] == 'success') {
                                  ErrorSnackBar.show(context, res['message']);
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
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
