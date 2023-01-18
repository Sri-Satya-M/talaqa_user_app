import 'package:alsan_app/data/network/api_client.dart';
import 'package:alsan_app/data/network/api_endpoints.dart';
import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/model/profile.dart';

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

  Future<Profile> getProfile() async {
    var response = await apiClient.get(Api.profile);
    return Profile.fromJson(response);
  }

  Future updateProfile({body}) async {
    return await apiClient.patch(Api.profile, body);
  }

  Future createPatient({body}) async {
    return await apiClient.post(Api.patientProfiles, body);
  }

  Future<List<Profile>> getPatients() async {
    var response = await apiClient.get(Api.patientProfiles);
    var list = response as List;
    return list.map((e) => Profile.fromJson(e)).toList();
  }

  Future updatePatients({id, body}) async {
    return await apiClient.patch('${Api.patientProfiles}/$id', body);
  }

  Future deletePatients({id}) async {
    return await apiClient.delete('${Api.patientProfiles}/$id');
  }

  Future<List<Clinicians>> getClinicians() async {
    var response = await apiClient.get(Api.clinicians);
    var list = response as List;
    return list.map((e) => Clinicians.fromJson(e)).toList();
  }
}
