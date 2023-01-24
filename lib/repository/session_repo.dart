import 'package:alsan_app/data/network/api_client.dart';

import '../data/network/api_endpoints.dart';
import '../model/mode_of_consultation.dart';

class SessionRepo {
  Future<List<ModeOfConsultation>> getModeOfConsultation() async {
    var response = await apiClient.get(Api.modeOfConsultation);
    var list = response as List;
    return list.map((e) => ModeOfConsultation.fromMap(e)).toList();
  }
}
