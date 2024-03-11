import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/session_bloc.dart';
import '../../../../../../model/service.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';
import '../widgets/service_card.dart';

class SelectServicePage extends StatefulWidget {
  final bool isClinician;
  final Function(Service) onTap;

  const SelectServicePage({
    super.key,
    required this.onTap,
    required this.isClinician,
  });

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
        future: widget.isClinician
            ? sessionBloc.getClinicianServices(
                id: '${sessionBloc.selectedClinician?.id}')
            : sessionBloc.getServices(query: {'offset': 0}),
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
                  onTap: () {
                    selectedIndex = services[index].id;
                    widget.onTap(services[index]);
                    setState(() {});
                  },
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
          );
        },
      ),
    );
  }
}
