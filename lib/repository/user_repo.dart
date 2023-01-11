import 'package:alsan_app/data/network/api_client.dart';
import 'package:alsan_app/data/network/api_endpoints.dart';

class UserRepo {
  Future sendOTP({body}) async {
    return await apiClient.post(Api.otp, body);
  }

  Future verifyOTP({body}) async {
    return await apiClient.post(Api.verifyOtp, body);
  }

  Future patientSignUp({body}) async {
    return await apiClient.post(Api.signUp, body);
  }

  Future signInEmail({body}) async {
    return await apiClient.post(Api.signInEmail, body);
  }

}
