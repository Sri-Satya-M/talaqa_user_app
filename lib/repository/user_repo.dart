import 'package:alsan_app/data/network/api_client.dart';
import 'package:alsan_app/data/local/shared_prefs.dart';
import 'package:alsan_app/data/network/api_endpoints.dart';

class UserRepo {
  Future login({body}) async {
    var response = await apiClient.post(Api.sendOtp, body);
    var token = await response['access_token'];
    await Prefs.setToken(token);
    return response;
  }
}
