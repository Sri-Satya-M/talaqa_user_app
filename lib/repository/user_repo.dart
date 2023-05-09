import 'package:alsan_app/data/network/api_client.dart';
import 'package:alsan_app/data/network/api_endpoints.dart';
import 'package:alsan_app/model/address.dart';
import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/model/medical_records.dart';
import 'package:alsan_app/model/profile.dart';
import 'package:alsan_app/model/resources.dart';
import 'package:dio/dio.dart';

import '../model/dashboard.dart';
import '../model/notification.dart';
import '../model/review.dart';

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

  Future<Profile> getPatientProfile({required String id}) async {
    var response = await apiClient.get(
      '${'${Api.patients}/${Api.patientProfile}'}/$id',
    );
    return Profile.fromJson(response);
  }

  Future<Profile> getProfile() async {
    var response = await apiClient.get(Api.profile);
    return Profile.fromJson(response);
  }

  Future updateProfile({body}) async {
    return await apiClient.patch(Api.profile, body);
  }

  Future<Profile> createPatient({body}) async {
    var response = await apiClient.post(Api.patientProfiles, body);
    return Profile.fromJson(response);
  }

  Future uploadFile({required String path}) async {
    var body = FormData.fromMap({'file': await MultipartFile.fromFile(path)});
    var response = await apiClient.post(Api.upload, body);
    return response;
  }

  Future uploadMedicalRecords({required body}) async {
    var response = await apiClient.post('${Api.medicalRecords}/upload', body);
    return response;
  }

  Future saveMedicalRecords({required body}) async {
    var response = await apiClient.post('${Api.medicalRecords}/save', body);
    return response;
  }

  Future<List<MedicalRecord>> getMedicalRecords({required query}) async {
    var response = await apiClient.get(Api.medicalRecords, query: query);
    var list = response['data'] as List;
    return list.map((e) => MedicalRecord.fromJson(e)).toList();
  }

  Future removeMedicalRecord({required String id}) async {
    return apiClient.delete('${Api.medicalRecords}/$id');
  }

  Future<List<Profile>> getPatients({required id}) async {
    var response = await apiClient.get('${Api.patientProfiles}/$id');
    var list = response['patientProfiles'] as List;
    return list.map((e) => Profile.fromJson(e)).toList();
  }

  Future updatePatients({id, body}) async {
    return await apiClient.patch('${Api.patientProfiles}/$id', body);
  }

  Future deletePatients({id}) async {
    return await apiClient.delete('${Api.patientProfiles}/$id');
  }

  Future<List<Clinician>> getClinicians({query}) async {
    var response = await apiClient.get(Api.clinicians, query: query);
    var list = response['clinicians'] as List;
    return list.map((e) => Clinician.fromMap(e)).toList();
  }

  Future<List<Clinician>> getAvailableClinicians({query}) async {
    var response = await apiClient.get(
      Api.sessions + Api.availableClinicians,
      query: query,
    );
    var list = response['clinicians'] as List;
    return list.map((e) => Clinician.fromMap(e)).toList();
  }

  Future<List<Resources>> getResources({query}) async {
    var response = await apiClient.get(Api.resources, query: query);
    var list = response['resources'] as List;
    return list.map((e) => Resources.fromJson(e)).toList();
  }

  Future<List<Address>> getAddresses() async {
    var response = await apiClient.get(Api.patients + Api.addresses);
    var list = response as List;
    return list.map((e) => Address.fromMap(e)).toList();
  }

  Future<Address> postAddress({body}) async {
    var response = await apiClient.post(Api.patients + Api.addresses, body);
    return Address.fromMap(response);
  }

  Future updateFCMToken({body}) {
    return apiClient.post(Api.tokens, body);
  }

  Future<List<Review>> getReview({required String id}) async {
    var response = await apiClient.get(Api.reviews, query: {'clinicianId': id});
    var list = response['reviews'] as List;
    return list.map((f) => Review.fromJson(f)).toList();
  }

  Future removeAddresses({required String id}) async {
    return await apiClient.delete('${Api.patients}${Api.addresses}/$id');
  }

  Future<Dashboard> getDashboard({required String id}) async {
    var response = await apiClient.get(
      '${Api.dashboard}/patient-profiles/$id',
    );
    return Dashboard.fromJson(response);
  }

  Future<List<Notification>> getNotifications({required query}) async {
    var response = await apiClient.get(Api.notifications, query: query);
    var list = response as List;
    return list.map((e) => Notification.fromJson(e)).toList();
  }
}
