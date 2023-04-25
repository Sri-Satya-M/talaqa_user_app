import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

import '../../../../resources/colors.dart';
import '../../../../resources/strings.dart';
import '../../../widgets/details_tile.dart';

class HowToUse extends StatelessWidget {
  HowToUse({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    var steps = [
      StepDetails(
        icon: Images.step1,
        title: '${langBloc.getString(Strings.step)} 1',
        subtitle: 'Select patient profile.',
      ),
      StepDetails(
        icon: Images.step2,
        title: '${langBloc.getString(Strings.step)} 2',
        subtitle: langBloc.getString(Strings.selectClinicianProfile),
      ),
      StepDetails(
        icon: Images.step3,
        title: '${langBloc.getString(Strings.step)} 3',
        subtitle: langBloc.getString(Strings.selectModeOfConsultation),
      ),
      StepDetails(
        icon: Images.step4,
        title: '${langBloc.getString(Strings.step)} 4',
        subtitle: langBloc.getString(Strings.selectASlot),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 48),
        Image.asset(Images.logo, width: 75, height: 100),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: '${langBloc.getString(Strings.howTo)} ',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: langBloc.getString(Strings.useTalaqaApp),
                style: const TextStyle(
                  fontSize: 24,
                  color: MyColors.darkGreenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: FixedTimeline.tileBuilder(
            theme: TimelineTheme.of(context).copyWith(
              nodePosition: 0,
              connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
                    thickness: 2.0,
                  ),
              indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
                    size: 20.0,
                  ),
            ),
            builder: TimelineTileBuilder(
              itemCount: steps.length,
              indicatorBuilder: (_, index) => SizedBox(
                height: 100.0,
                child: TimelineNode(
                  indicator: Card(
                    margin: EdgeInsets.zero,
                    child: Image.asset(
                      steps[index].icon,
                      height: 60,
                      width: 60,
                    ),
                  ),
                  startConnector: (index == 0) ? null : getConnector(),
                  endConnector:
                      (index == steps.length - 1) ? null : getConnector(),
                ),
              ),
              itemExtentBuilder: (_, index) => 100,
              nodeItemOverlapBuilder: (_, index) =>
                  (index != 0 || index != 5) ? true : null,
              contentsBuilder: (_, index) {
                return DetailsTile(
                  padding: const EdgeInsets.only(left: 16),
                  title: Text(steps[index].title, style: textTheme.headline5),
                  value: Text(
                    steps[index].subtitle,
                    style: textTheme.caption,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget getConnector() {
    return const DashedLineConnector(
      color: Colors.grey,
      thickness: 0.5,
      dash: 3,
      gap: 5,
    );
  }
}

class StepDetails {
  final String icon;
  final String title;
  final String subtitle;

  StepDetails({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
