import 'package:flutter/cupertino.dart';

import '../model/mode_of_consultation.dart';
import '../model/time_of_day.dart';
import '../repository/session_repo.dart';

class SessionBloc with ChangeNotifier {
  final sessionRepo = SessionRepo();

  Future<List<ModeOfConsultation>> getModeOfConsultation() {
    return sessionRepo.getModeOfConsultation();
  }

  Future<TimeOfDay> getTimeSlots({required String id, query}) async {
    return sessionRepo.getTimeSlots(id: id, query: query);
  }
}
