import 'package:flutter/cupertino.dart';

import '../model/clinicians.dart';
import '../model/mode_of_consultation.dart';
import '../model/profile.dart';
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
}
