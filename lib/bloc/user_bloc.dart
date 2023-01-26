import 'package:alsan_app/model/address.dart';
import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/model/profile.dart';
import 'package:alsan_app/repository/user_repo.dart';
import 'package:flutter/cupertino.dart';

import '../data/local/shared_prefs.dart';
import '../model/resources.dart';

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

  Future createPatient({body}) {
    return _userRepo.createPatient(body: body);
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
}
