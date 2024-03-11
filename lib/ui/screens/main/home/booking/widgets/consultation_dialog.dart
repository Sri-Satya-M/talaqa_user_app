import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/model/mode_of_consultation.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/image_from_net.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/strings.dart';
import '../../../../../widgets/details_tile.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';

class ConsultationDialog extends StatefulWidget {
  const ConsultationDialog({super.key});

  static Future open(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return showDialog<ModeOfConsultation?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(langBloc.getString(Strings.modeOfConsultation),
                  style: textTheme.headline4),
              IconButton(
                onPressed: () => Navigator.pop(context, null),
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          elevation: 5,
          content: const ConsultationDialog(),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        );
      },
    );
  }

  @override
  _ConsultationDialogState createState() => _ConsultationDialogState();
}

class _ConsultationDialogState extends State<ConsultationDialog> {
  int? selected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return SizedBox(
      height: 450,
      width: double.maxFinite,
      child: FutureBuilder<List<ModeOfConsultation>>(
        future: sessionBloc.getModeOfConsultation(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }
          if (!snapshot.hasData) return const LoadingWidget();

          var consultations = snapshot.data ?? [];
          if (consultations.isEmpty) return const EmptyWidget();
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            physics: const ScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              const Divider(),
              const SizedBox(height: 8),
              for (int i = 0; i < consultations.length; i++)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = consultations[i].id!;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: (selected == consultations[i].id)
                            ? MyColors.primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        DetailsTile(
                          title: Row(
                            children: [
                              ImageFromNet(
                                imageUrl: consultations[i].imageUrl,
                                width: 12,
                              ),
                              const SizedBox(width: 6),
                              Text(consultations[i].title ?? 'NA'),
                            ],
                          ),
                          value: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: const BoxDecoration(
                              color: MyColors.lightBlue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Text(
                                '${consultations[i].price} ${langBloc.getString(Strings.dirham)}'),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Radio(
                          value: consultations[i].id,
                          groupValue: selected,
                          onChanged: (value) {
                            setState(() {
                              selected = value as int;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                onPressed: () {
                  var consultationMode = consultations.firstWhere(
                    (e) => e.id == selected,
                  );
                  Navigator.pop(context, consultationMode);
                },
                child: Text(langBloc.getString(Strings.bookNow)),
              ),
            ],
          );
        },
      ),
    );
  }
}
