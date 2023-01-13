import 'dart:io';

import 'package:dio/dio.dart';
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
            .map((e) => e[0].toUpperCase() + e.substring(1,).toLowerCase())
            .toList()
            .join(' ');
    return a;
  }
}
