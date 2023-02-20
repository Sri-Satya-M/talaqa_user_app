import 'package:flutter/cupertino.dart';

import '../model/clinicians.dart';
import '../model/meeting.dart';
import '../model/mode_of_consultation.dart';
import '../model/profile.dart';
import '../model/session.dart';
import '../model/time_of_day.dart';
import '../repository/session_repo.dart';

class SessionBloc with ChangeNotifier {
  final sessionRepo = SessionRepo();

  Clinician? selectedClinician;
  Profile? selectedPatient;

  ModeOfConsultation? selectedModeOfConsultation;
  DateTime? selectedDate;
  List<int>? selectedTimeSlotIds;
  String? description;
  int? selectedAddressId;
  Map<int, TimeSlot> timeslots = {};

  Future<List<ModeOfConsultation>> getModeOfConsultation() {
    return sessionRepo.getModeOfConsultation();
  }

  Future<TimeOfDay> getTimeSlots({required String id, query}) async {
    return sessionRepo.getTimeSlots(id: id, query: query);
  }

  Future createSessions({body}) {
    return sessionRepo.createSessions(body: body);
  }

  setDate({required DateTime date}) {
    selectedTimeSlotIds?.clear();
    selectedDate = date;
    notifyListeners();
  }

  setModeOfConsultation({ModeOfConsultation? modeOfConsultation}) {
    selectedModeOfConsultation = modeOfConsultation;
    notifyListeners();
  }

  setDescription({String? description}) {
    this.description = description;
    notifyListeners();
  }

  setAddress({int? addressId}) {
    selectedAddressId = addressId;
    notifyListeners();
  }

  clear() {
    selectedClinician = null;
    selectedPatient = null;
    selectedModeOfConsultation = null;
    selectedDate = null;
    selectedTimeSlotIds?.clear();
    description = null;
    selectedAddressId = null;
    timeslots.clear();
    // notifyListeners();
  }

  ///Apis

  Future<List<Session>> getSessions({query}) {
    return sessionRepo.getSessions(query: query);
  }

  Future<Session> getSessionById(String id) async {
    return await sessionRepo.getSessionById(id);
  }

  Future updateSession({body}) async {
    return await sessionRepo.updateSession(body: body);
  }

  Future postPaymentDetails({required int id, required body}) async {
    return await sessionRepo.postPaymentDetails(id: id, body: body);
  }

  Future<Meeting> joinMeeting({required int id}) async {
    return await sessionRepo.joinMeeting(id: id);
  }

  Future generateToken(String channel, int userId) {
    return sessionRepo.generateToken(channel, userId);
  }
}
