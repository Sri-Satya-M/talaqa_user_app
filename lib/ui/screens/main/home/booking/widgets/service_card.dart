import 'package:alsan_app/model/service.dart';
import 'package:flutter/material.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/images.dart';
import '../../../../../widgets/reverse_details_tile.dart';

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: MyColors.cementShade1,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Image.asset(Images.voice),
              const SizedBox(width: 16),
              Text(service.title!, style: textTheme.headline5),
            ],
          ),
          const SizedBox(height: 16),
          ReverseDetailsTile(
            title: const Text('Symptoms'),
            value: Text(
              service.symptoms?.map((e) => e.title).toList().join(", ") ?? 'NA',
              style: textTheme.bodyText1,
            ),
          ),
          const SizedBox(height: 16),
          ReverseDetailsTile(
            title: const Text('Description'),
            value: Text(
              service.description ?? 'NA',
              style: textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
