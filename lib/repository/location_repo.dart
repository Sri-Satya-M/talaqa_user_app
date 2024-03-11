import 'package:alsan_app/data/network/api_client.dart';
import 'package:dio/dio.dart';

import '../data/network/api_endpoints.dart';
import '../data/network/pretty_dio_logger.dart';

class LocationRepo {
  late Dio dio;

  LocationRepo() {
    dio = Dio();
    dio.interceptors.add(
      PrettyDioLogger(maxWidth: 80, error: true, requestBody: true),
    );
  }

  Future autoComplete(String search) async {
    var query = {'key': apiClient.mapsKey, 'input': '{$search}'};
    var res = await dio.get(
      Api.mapAutoComplete,
      queryParameters: query,
    );
    return res.data;
  }

  Future decodePlace(String placeId) async {
    var query = {
      'key': apiClient.mapsKey,
      'placeid': placeId,
    };
    var res = await dio.get(
      Api.mapDecodePlace,
      queryParameters: query,
    );
    return res.data;
  }
}
