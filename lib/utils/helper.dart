import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:path_provider/path_provider.dart';

import '../model/address.dart';
import '../model/duration_time.dart';

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

  static textCapitalization({required String? text}) {
    if (text == null) return 'NA';
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

  static String formatDate({
    required DateTime? date,
    String pattern = 'yyyy-MM-dd',
  }) {
    if (date == null) return 'NA';
    return DateFormat(pattern).format(date);
  }

  static downloadFiles({required List<String> urls}) async {
    try {
      String directory;
      bool isAndroid = Platform.isAndroid;

      if (isAndroid) {
        directory = "/storage/emulated/0/Download";
      } else {
        directory =
            '${(await getApplicationDocumentsDirectory()).path ?? ''}/Talaqa';
      }

      print(directory);
      print(urls);

      for (var url in urls) {
        String fileName = url.split('/').last;
        print('$directory/$fileName');
        await Dio().download(url, '$directory/$fileName');
      }

      return 'Downloaded Successfully';
    } catch (e) {
      return 'Error while Downloading';
    }
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

  static String getDuration(List<DurationTime>? duration) {
    if (duration == null || duration.isEmpty) return 'NA';
    int minutes =
        duration.map((e) => e.duration!).toList().reduce((a, b) => a + b);
    Duration aggDuration = Duration(minutes: minutes);
    final HH = (aggDuration.inHours).toString().padLeft(2, '0');
    final mm = (aggDuration.inMinutes % 60).toString().padLeft(2, '0');
    return '$HH:$mm Hrs';
  }

  static String formatDurationInHhMmSs({required Duration duration}) {
    final HH = (duration.inHours).toString().padLeft(2, '0');
    final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$HH:$mm:$ss';
  }

  static String formatAddress({Address? address}) {
    if (address == null) return '';
    String addressLine2 = address.addressLine2 ?? '';
    String landmark = address.landmark ?? '';
    String city = address.city ?? '';
    String country = address.country ?? '';
    String pincode = address.pincode ?? '';

    List<String> result = [addressLine2, landmark, city, country, pincode];
    return result.join(',');
  }

  static int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  static Future<List<File>?> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      return files;
    }
    return null;
  }

  static Future<void> openMap({
    double? latitude,
    double? longitude,
    required String name,
    required String address,
  }) async {
    if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(latitude ?? 17.3850, longitude ?? 78.4867),
        title: name,
        description: address,
        zoom: 14,
      );
    }
  }
}
