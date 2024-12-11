import 'dart:async';

import 'package:alsan_app/model/service.dart';
import 'package:flutter/cupertino.dart';

// import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../model/address.dart';
import '../model/chat.dart';
import '../model/clinicians.dart';
import '../model/mode_of_consultation.dart';
import '../model/profile.dart';
import '../model/reports.dart';
import '../model/session.dart';
import '../model/time_of_day.dart';
import '../repository/session_repo.dart';

class SessionBloc with ChangeNotifier {
  final sessionRepo = SessionRepo();

  Clinician? selectedClinician;
  Profile? selectedPatient;

  ModeOfConsultation? selectedModeOfConsultation;
  String? symptom;
  Service? service;
  DateTime? selectedDate;
  List<int>? selectedTimeSlotIds;
  String? description;
  int? selectedAddressId;
  int selectedStatement = -1;
  Map<int, TimeSlot> timeslots = {};
  Address? selectedAddress;

  ///chat
  List<Message> messages = [];
  late StreamController<List<Message>> messageController;

  Stream<List<Message>> get messageListStream => messageController.stream;

  Future<List<ModeOfConsultation>> getModeOfConsultation() {
    return sessionRepo.getModeOfConsultation();
  }

  Future<List<TimeOfDay>> getTimeSlots({query}) async {
    return sessionRepo.getTimeSlots(query: query);
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

  clear(bool isClinician) {
    selectedPatient = null;
    service = null;
    symptom = null;
    selectedModeOfConsultation = null;
    selectedDate = null;
    selectedTimeSlotIds?.clear();
    description = null;
    if (!isClinician) {
      selectedClinician = null;
    }
    selectedAddressId = null;
    timeslots.clear();
    notifyListeners();
  }

  ///Apis

  Future<List<Session>> getSessions({query}) {
    return sessionRepo.getSessions(query: query);
  }

  Future<Session> getSessionById(String id) async {
    return await sessionRepo.getSessionById(id);
  }

  Future updateSession({required String id, body}) async {
    return await sessionRepo.updateSession(id: id, body: body);
  }

  Future postPaymentDetails({required num id, required body}) async {
    return await sessionRepo.postPaymentDetails(id: id, body: body);
  }

  Future joinSession({required query}) async {
    return await sessionRepo.joinSession(query: query);
  }

  Future generateToken(String channel, int userId) {
    return sessionRepo.generateToken(channel, userId);
  }

  Future postSessionFeedback({required num id, body}) {
    return sessionRepo.postSessionFeedback(id: id, body: body);
  }

  Future<List<Report>> getSessionReports({required num id, required query}) {
    return sessionRepo.getSessionReports(id: id, query: query);
  }

  Future<List<String>> getPatientSymptoms() {
    return sessionRepo.getPatientSymptoms();
  }

  Future updateSessionClinician({required String id, required body}) {
    return sessionRepo.updateSessionClinician(id: id, body: body);
  }

  Future postDuration({required body}) {
    return sessionRepo.postDuration(body: body);
  }

  Future<List<TimeOfDay>> getClinicianAvailableTimeSlots({
    required String id,
    required query,
  }) async {
    return await sessionRepo.getClinicianAvailableTimeSlots(
      id: id,
      query: query,
    );
  }

  Future<Services> getServices({required query}) {
    return sessionRepo.getServices(query: query);
  }

  Future<Services> getClinicianServices({required String id}) async {
    return sessionRepo.getClinicianServices(id: id);
  }

  ///Handling chat in bloc
  initializeStream() {
    messages.clear();
    messageController = StreamController<List<Message>>.broadcast();
  }

  void addMessage(Message message) {
    messages.add(message);
    messageController.add(messages);
  }

  @override
  dispose() {
    messages.clear();
    messageController.close();
    super.dispose();
  }
}
