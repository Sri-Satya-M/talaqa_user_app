import 'package:alsan_app/model/service.dart';
import 'package:flutter/material.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../widgets/reverse_details_tile.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback? onTap;

  const ServiceCard({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
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
            Text(service.title ?? '--', style: textTheme.headlineSmall),
            const SizedBox(height: 16),
            ReverseDetailsTile(
              title: const Text('Symptoms'),
              value: Text(
                service.symptoms?.map((e) => e.title).toList().join(", ") ??
                    'NA',
                style: textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 16),
            ReverseDetailsTile(
              title: const Text('Description'),
              value: Text(
                service.description ?? 'NA',
                style: textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
