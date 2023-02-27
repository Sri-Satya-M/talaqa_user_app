import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Helper {
  static checkKnowledgeCenter({required List<String> urls}) async {
    List<File?> exists = [];
    var dir = await getExternalStorageDirectory();
    for (String url in urls) {
      var fileName = url.split('/').last;
      var path = '${dir!.path}/$fileName';
      var file = File(path);
      file.existsSync() ? exists.add(file) : exists.add(null);
    }
    return exists;
  }

  static downloadFromUrl(String url) async {
    Dio dio = Dio();
    var dir = await getExternalStorageDirectory();
    String fileName = url.split('/').last;
    String saveTo = '${dir!.path}/$fileName';
    await dio.download(url, saveTo);
    return saveTo;
  }

  static textCapitalization({required String text}) {
    var a = text
        .split(' ')
        .map((e) =>
            e[0].toUpperCase() +
            e
                .substring(
                  1,
                )
                .toLowerCase())
        .toList()
        .join(' ');
    return a;
  }

  static String formatDate(
      {required DateTime? date, String pattern = 'yyyy-MM-dd'}) {
    if (date == null) return 'NA';
    return DateFormat(pattern).format(date);
  }

  ///Parameter format
  ///List<dynamic> collection=>send a list of objects in json format
  ///key=> send a key in string format which is in the above collection
  ///object=> send a fromMap function that is in the model
  ///example: sortByKey(collection: currentObj.map((co)=>co.toJson()).toList(), key: "parameterName",obj: (json)=>ClassName.fromMap(json))
  static List<dynamic> sortByKey({
    required List<dynamic> collection,
    required String key,
    required Function(Map<String, dynamic>) obj,
  }) {
    collection.sort((a, b) => a[key].compareTo(b[key]));
    return collection.map((json) => obj.call(json)).toList();
  }

  String formatDurationInHhMmSs(Duration duration) {
    final HH = (duration.inHours).toString().padLeft(2, '0');
    final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$HH:$mm:$ss';
  }
}
