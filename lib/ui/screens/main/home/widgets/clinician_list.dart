import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/user_bloc.dart';
import '../../../../../model/clinicians.dart';
import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';
import 'doctor_card.dart';

class ClinicianList extends StatefulWidget {
  final Axis scrollDirection;

  const ClinicianList({super.key, required this.scrollDirection});

  @override
  _ClinicianListState createState() => _ClinicianListState();
}

class _ClinicianListState extends State<ClinicianList> {
  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return FutureBuilder<List<Clinicians>>(
      future: userBloc.getClinicians(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(error: snapshot.error);
        }
        if (!snapshot.hasData) return const LoadingWidget();
        var clinicians = snapshot.data ?? [];
        if (clinicians.isEmpty) return const EmptyWidget();
        return ListView.builder(
          scrollDirection: widget.scrollDirection,
          itemCount: clinicians.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(
            right: (widget.scrollDirection == Axis.horizontal) ? 8 : 0,
          ),
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) => DoctorCard(
            name: clinicians[index].user?.fullName ?? 'NA',
            image: clinicians[index].image ?? 'NA',
            languages: "English",
            specialization: clinicians[index].designation ?? 'NA',
            experience: clinicians[index].experience ?? -1,
          ),
        );
      },
    );
  }
}
