import 'package:flutter/cupertino.dart';

import '../model/mode_of_consultation.dart';
import '../repository/session_repo.dart';

class SessionBloc with ChangeNotifier {
  final sessionRepo = SessionRepo();

  Future<List<ModeOfConsultation>> getModeOfConsultation() {
    return sessionRepo.getModeOfConsultation();
  }
}
