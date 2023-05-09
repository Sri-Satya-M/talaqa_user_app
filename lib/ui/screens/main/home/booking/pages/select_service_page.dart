import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/model/service.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';

class SelectServicePage extends StatefulWidget {
  final Function(Service) onTap;

  const SelectServicePage({super.key, required this.onTap});

  @override
  _SelectServicePageState createState() => _SelectServicePageState();
}

class _SelectServicePageState extends State<SelectServicePage> {
  int? selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: FutureBuilder<Services>(
        future: sessionBloc.getServices(query: {}),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }

          if (!snapshot.hasData) return const LoadingWidget();

          var services = snapshot.data?.services ?? [];

          if (services.isEmpty) return const EmptyWidget();

          return ListView.builder(
            itemCount: services.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) => Stack(
              children: [
                ServiceCard(
                  service: services[index],
                ),
                Positioned(
                  top: 20,
                  right: 10,
                  child: Radio(
                    value: services[index].id,
                    groupValue: selectedIndex,
                    onChanged: (value) {
                      selectedIndex = services[index].id;
                      widget.onTap(services[index]);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            //     Container(
            //   padding: const EdgeInsets.all(16),
            //   margin: const EdgeInsets.symmetric(vertical: 8),
            //   decoration: BoxDecoration(
            //     color: MyColors.cement,
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            //   child:
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: [
            //       Row(
            //         children: [
            //           Image.asset(Images.voice),
            //           const SizedBox(width: 16),
            //           Text(services[index].title!, style: textTheme.headline5),
            //           const Spacer(),
            //           Radio(
            //             value: services[index].id,
            //             groupValue: selectedIndex,
            //             onChanged: (value) {
            //               selectedIndex = services[index].id;
            //               widget.onTap(services[index]);
            //               setState(() {});
            //             },
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 16),
            //       ReverseDetailsTile(
            //         title: const Text('Symptoms'),
            //         value: Text(
            //           services[index]
            //                   .symptoms
            //                   ?.map((e) => e.title)
            //                   .toList()
            //                   .join(", ") ??
            //               'NA',
            //           style: textTheme.bodyText1,
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //       ReverseDetailsTile(
            //         title: const Text('Description'),
            //         value: Text(
            //           services[index].description ?? 'NA',
            //           style: textTheme.bodyText1,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          );
        },
      ),
    );
  }
}
