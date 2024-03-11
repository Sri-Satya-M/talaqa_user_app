import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../bloc/language_bloc.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../widgets/custom_card.dart';
import '../widgets/select_clinician_widget.dart';

class SelectClinician extends StatefulWidget {
  final String serviceId;
  final bool isClinician;

  const SelectClinician({
    super.key,
    required this.serviceId,
    required this.isClinician,
  });

  @override
  State<SelectClinician> createState() => _SelectClinicianState();
}

class _SelectClinicianState extends State<SelectClinician> {
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
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ListView(
        children: [
          CustomCard(
            child: TextFormField(
              style: textTheme.bodyLarge?.copyWith(fontSize: 16),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                hintText: langBloc.getString(Strings.searchByClinicianName),
                hintStyle: textTheme.bodySmall?.copyWith(fontSize: 14),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: onSearch,
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder<String>(
            stream: searchStream,
            builder: (context, snapshot) {
              var search = snapshot.data ?? '';
              return SelectClinicianWidget(
                key: ValueKey(search),
                serviceId: widget.serviceId,
                search: search,
                isClinician: widget.isClinician,
              );
            },
          ),
        ],
      ),
    );
  }
}
