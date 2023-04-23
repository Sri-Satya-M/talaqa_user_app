import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../resources/colors.dart';
import '../../../widgets/progress_button.dart';

class LocationSearchBox extends StatefulWidget {
  final Function onTap;

  const LocationSearchBox({super.key, required this.onTap});

  @override
  _LocationSearchBoxState createState() => _LocationSearchBoxState();
}

class _LocationSearchBoxState extends State<LocationSearchBox> {
  final _debouncer = BehaviorSubject<String>();
  bool expanded = false;
  bool loading = false;
  List results = [];

  void search(String s) async {
    if (s.isEmpty) return;
    loading = true;
    setState(() {});
    var res = await LocationBloc().autoComplete(s);
    if (res['status'] != 'OK') {
      loading = false;
      setState(() {});
      // return ErrorSnackBar.show(context, 'Unable to fetch');
    }
    results.clear();
    results.addAll(res['predictions'] as List);
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _debouncer.debounceTime(const Duration(milliseconds: 600)).listen(search);
  }

  @override
  void dispose() {
    _debouncer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var locationBloc = Provider.of<LocationBloc>(context, listen: false);
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () {
            setState(() => expanded = !expanded);
          },
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.bottomCenter,
            child: expanded
                ? Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          hintText: 'Type location you want...',
                          hintStyle: textTheme.caption,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(18),
                          suffixIcon: loading
                              ? const SizedBox(
                                  width: 32,
                                  child: Center(
                                    child: SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          if (value == null || value.isEmpty) {
                            results.clear();
                            expanded = false;
                            setState(() {});
                          }
                          _debouncer.add(value);
                        },
                      ),
                      if (results.isNotEmpty) const Divider(),
                      for (var item in results)
                        ListTile(
                          title: Text(
                            item['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            expanded = false;
                            results.clear();
                            setState(() {});
                            ProgressUtils.handleProgress(
                              context,
                              task: () async {
                                var res = await locationBloc.decodePlace(
                                  item['place_id'],
                                );
                                if (res['status'] != 'OK') {
                                  throw Exception('Unable to fetch');
                                }
                                var location =
                                    res['result']['geometry']['location'];

                                var latLng = LatLng(
                                  location['lat'],
                                  location['lng'],
                                );
                                widget.onTap(latLng);
                              },
                            );
                          },
                        ),
                    ],
                  )
                : Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Type location you want...',
                          style: textTheme.caption,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(16),
                        child: const Icon(
                          Icons.search_outlined,
                          color: MyColors.primaryColor,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
