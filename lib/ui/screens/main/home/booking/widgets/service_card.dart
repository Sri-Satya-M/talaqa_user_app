import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/model/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../widgets/details_tile.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback? onTap;

  const ServiceCard({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: MyColors.cementShade1,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              langBloc.currentLanguageText == 'English'
                  ? service.title ?? 'NA'
                  : service.arabicTitle ?? 'NA',
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            DetailsTile(
              title: Text(langBloc.getString(Strings.description)),
              value: Text(
                langBloc.currentLanguageText == 'English'
                    ? service.description ?? 'NA'
                    : service.arabicDescription ?? 'NA',
                style: textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              langBloc.getString(Strings.symptoms),
              style: textTheme.bodyMedium,
            ),
            for (var i = 0; i < service.symptoms!.length; i++) ...[
              Text(
                '${i + 1}. ${langBloc.currentLanguageText == 'English' ? '${service.symptoms?[i].title ?? 'NA'}' : '${service.symptoms?[i].arabic ?? ' '}'}',
                style: textTheme.titleSmall!.copyWith(height: 1.4),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
