import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../resources/strings.dart';
import 'booking/booking_screen.dart';
import 'widgets/clinician_list.dart';

class SelectClinicians extends StatefulWidget {
  @override
  _SelectCliniciansState createState() => _SelectCliniciansState();
}

class _SelectCliniciansState extends State<SelectClinicians> {
  final searchSubject = BehaviorSubject<String>();
  final searchCtrl = TextEditingController();
  Stream<String>? searchStream;

  @override
  void initState() {
    super.initState();
    searchStream = searchSubject.debounceTime(
      const Duration(milliseconds: 600),
    );
  }

  void onSearch(String value) {
    searchSubject.add(value);
  }

  @override
  void dispose() {
    searchSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.clinicians))),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          CustomCard(
            child: TextFormField(
              style: textTheme.bodyText1?.copyWith(fontSize: 16),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                hintText: langBloc.getString(Strings.searchByClinicianName),
                hintStyle: textTheme.caption?.copyWith(fontSize: 14),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: onSearch,
            ),
          ),
          StreamBuilder<String>(
            stream: searchStream,
            builder: (context, snapshot) {
              var search = snapshot.data ?? '';
              return ClinicianList(
                key: ValueKey(search),
                search: search,
                scrollDirection: Axis.vertical,
                onTap: (clinician) {
                  BookingScreen.open(context, clinician: clinician);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
