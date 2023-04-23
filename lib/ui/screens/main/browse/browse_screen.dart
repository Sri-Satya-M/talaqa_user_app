import 'dart:async';

import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/ui/screens/main/home/booking/booking_screen.dart';
import 'package:alsan_app/ui/screens/main/home/widgets/clinician_list.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../resources/strings.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  _BrowseScreenState createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
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
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      physics: const ScrollPhysics(),
      children: [
        CustomCard(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: searchCtrl,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    hintText: langBloc.getString(Strings.searchByClinicianName),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: onSearch,
                ),
              ),
              InkWell(
                onTap: () {},
                child: const Icon(Icons.tune),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          langBloc.getString(Strings.topRatedClinicians),
          style: textTheme.subtitle2,
        ),
        const SizedBox(height: 12),
        StreamBuilder<String>(
          stream: searchStream,
          builder: (context, snapshot) {
            var search = snapshot.data ?? '';
            return ClinicianList(
              search: search,
              scrollDirection: Axis.vertical,
              onTap: (clinician) {
                BookingScreen.open(context, clinician: clinician);
              },
            );
          },
        ),
      ],
    );
  }
}
