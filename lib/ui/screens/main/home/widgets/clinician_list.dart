import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/user_bloc.dart';
import '../../../../../model/clinicians.dart';
import '../../../../widgets/loading_widget.dart';
import 'doctor_card.dart';

class ClinicianList extends StatefulWidget {
  final Axis scrollDirection;
  final String search;

  const ClinicianList({
    super.key,
    required this.scrollDirection,
    this.search = '',
  });

  @override
  _ClinicianListState createState() => _ClinicianListState();
}

class _ClinicianListState extends State<ClinicianList> {
  bool state = false;

  bool isFinished = false;
  bool isLoading = false;
  List<Clinician> clinicians = [];

  Future<void> fetchMore() async {
    if (isFinished || isLoading) return;
    isLoading = true;
    try {
      var limit = 20;
      var query = {
        'offset': clinicians.length.toString(),
        'limit': limit.toString(),
      };

      if (widget.search.isNotEmpty) {
        query['search'] = widget.search;
      }

      var list = await context.read<UserBloc>().getClinicians(query: query);
      clinicians.addAll(list);

      if (list.length < limit) isFinished = true;
    } catch (e) {
      isFinished = true;
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return ListView.builder(
      scrollDirection: widget.scrollDirection,
      itemCount: clinicians.length + ((isFinished) ? 0 : 1),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        if (index == clinicians.length) {
          fetchMore();
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const LoadingWidget(),
                  const SizedBox(height: 8),
                  Text(
                    'Fetching more Clinicians',
                    style: textTheme.bodySmall!.copyWith(
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return DoctorCard(clinician: clinicians[index]);
      },
    );
  }
}
