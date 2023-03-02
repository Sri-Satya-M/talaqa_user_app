import 'package:alsan_app/data/network/api_client.dart';
import 'package:alsan_app/data/network/api_endpoints.dart';
import 'package:alsan_app/model/address.dart';
import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/model/profile.dart';
import 'package:alsan_app/model/resources.dart';
import 'package:dio/dio.dart';

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

  Future<List<Clinician>> getClinicians() async {
    var response = await apiClient.get(Api.clinicians);
    var list = response as List;
    return list.map((e) => Clinician.fromMap(e)).toList();
  }

  Future<List<Resources>> getResources({query}) async {
    var response = await apiClient.get(Api.resources, query: query);
    var list = response as List;
    return list.map((e) => Resources.fromJson(e)).toList();
  }

  Future<List<Address>> getAddresses() async {
    var response = await apiClient.get(Api.patient + Api.addresses);
    var list = response as List;
    return list.map((e) => Address.fromMap(e)).toList();
  }

  Future<Address> postAddress({body}) async {
    var response = await apiClient.post(Api.patient + Api.addresses, body);
    return Address.fromMap(response);
  }

  Future uploadFile({required String path}) async {
    print(path);
    var body = FormData.fromMap({'file': await MultipartFile.fromFile(path)});
    var response = await apiClient.post(Api.upload, body);
    return response;
  }

  Future updateFCMToken({body}) {
    return apiClient.post(Api.tokens, body);
  }
}
