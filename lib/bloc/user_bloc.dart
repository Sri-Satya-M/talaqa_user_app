import 'package:alsan_app/model/address.dart';
import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/model/feedback.dart';
import 'package:alsan_app/model/medical_records.dart';
import 'package:alsan_app/model/profile.dart';
import 'package:alsan_app/repository/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/local/shared_prefs.dart';
import '../model/dashboard.dart';
import '../model/resources.dart';
import '../model/notification.dart' as n;

class UserBloc with ChangeNotifier {
  final _userRepo = UserRepo();

  String username = '';

  Profile? profile;

  Future sendOTP({body}) {
    return _userRepo.sendOTP(body: body);
  }

  Future verifyOTP({body}) {
    return _userRepo.verifyOTP(body: body);
  }

  Future patientSignUp({body}) {
    return _userRepo.patientSignUp(body: body);
  }

  Future signInEmail({body}) {
    return _userRepo.signInEmail(body: body);
  }

  void logout() async {
    await Prefs.clearPrefs();
  }

  Future getProfile() async {
    profile = await _userRepo.getProfile();
    notifyListeners();
  }

  Future<Profile> getPatientProfile({required String id}) async {
    return _userRepo.getPatientProfile(id: id);
  }

  Future updateProfile({body}) async {
    var response = await _userRepo.updateProfile(
      body: body,
    ) as Map<String, dynamic>;
    if (response.containsKey('status') && response["status"] == "success") {
      await getProfile();
      notifyListeners();
      return (response);
    }
  }

  Future<Profile> createPatient({body}) {
    return _userRepo.createPatient(body: body);
  }

  Future uploadFile(String path) {
    return _userRepo.uploadFile(path: path);
  }

  Future uploadMedicalRecords({required body}) {
    return _userRepo.uploadMedicalRecords(body: body);
  }

  Future saveMedicalRecords({required body}) {
    return _userRepo.saveMedicalRecords(body: body);
  }

  Future<List<MedicalRecord>> getMedicalRecords({required query}) {
    return _userRepo.getMedicalRecords(query: query);
  }

  Future removeMedicalRecord({required String id}) async {
    return _userRepo.removeMedicalRecord(id: id);
  }

  Future<List<dynamic>> uploadFiles({required List<String> paths, body}) async {
    var data = [];

    for (String path in paths) {
      try {
        data.add(
          FormData.fromMap(
            {...body, 'file': await MultipartFile.fromFile(path)},
          ),
        );
      } catch (e) {}
    }
    return data;
  }

  Future<List<Profile>> getPatients() {
    return _userRepo.getPatients();
  }

  Future updatePatients({id, body}) async {
    return await _userRepo.updatePatients(id: id, body: body);
  }

  Future<bool> deletePatients(id) async {
    var response = await _userRepo.deletePatients(
      id: id,
    ) as Map<String, dynamic>;
    return response.containsKey('id') ? true : false;
  }

  Future<List<Clinician>> getClinicians() {
    return _userRepo.getClinicians();
  }

  Future<List<Resources>> getResources({query}) {
    return _userRepo.getResources(query: query);
  }

  Future<List<Address>> getAddresses() {
    return _userRepo.getAddresses();
  }

  Future<Address> postAddress({body}) async {
    var response = await _userRepo.postAddress(body: body);
    notifyListeners();
    return response;
  }

  void updateFCMToken() async {
    await Permission.notification.request();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    var fcmToken = await messaging.getToken();
    print('FCM token: $fcmToken');
    var body = {'token': fcmToken, 'type': profile!.user!.userType!};
    await _userRepo.updateFCMToken(body: body);
  }

  Future<List<Feedback>> getFeedback({required String id}) {
    return _userRepo.getFeedback(id: id);
  }

  Future removeAddresses({required String id}) async {
    var response = await _userRepo.removeAddresses(id: id);
    notifyListeners();
    return response;
  }

  Future<Dashboard> getDashboard({required String id}) {
    return _userRepo.getDashboard(id: id);
  }

  Future<List<n.Notification>> getNotifications({required query}) {
    return _userRepo.getNotifications(query: query);
  }
}
