import 'package:alsan_app/data/network/api_client.dart';
import 'package:alsan_app/model/time_of_day.dart';

import '../data/network/api_endpoints.dart';
import '../model/meeting.dart';
import '../model/mode_of_consultation.dart';
import '../model/session.dart';

class SessionRepo {
  Future<List<ModeOfConsultation>> getModeOfConsultation() async {
    var response = await apiClient.get(Api.modeOfConsultation);
    var list = response as List;
    return list.map((e) => ModeOfConsultation.fromMap(e)).toList();
  }

  Future<TimeOfDay> getTimeSlots({required String id, query}) async {
    var response = await apiClient.get(
      '${Api.clinicianTimeSlot}${Api.clinician}/$id',
      query: query,
    );
    return TimeOfDay.fromMap(response);
  }

  Future createSessions({body}) {
    return apiClient.post(Api.sessions, body);
  }

  Future<List<Session>> getSessions({query}) async {
    var response = await apiClient.get(
      Api.sessions + Api.patientSessions,
      query: query,
    );
    var list = response as List;
    return list.map((e) => Session.fromMap(e)).toList();
  }

  Future<Session> getSessionById(String id) async {
    var response = await apiClient.get("${Api.sessions}/$id");
    return Session.fromMap(response);
  }

  Future updateSession({required int id, body}) {
    return apiClient.patch('${Api.updateSession}/$id', body);
  }

  Future<Meeting> joinMeeting({required int id}) async {
    var response = await apiClient.get('${Api.meeting}/$id');
    return Meeting.fromJson(response);
  }

  Future postPaymentDetails({required int id, required body}) async {
    var response = await apiClient.post('${Api.payment}/$id', body);
    return response;
  }

  Future generateToken(String channel, int userId) async {
    return await apiClient.post(
      '${Api.sessions}/token',
      {"channel": channel, "userId": userId},
    );
  }

  Future postSessionFeedback({required int id, body}) {
    return apiClient.post('${Api.sessions}/feedback/$id', body);
  }
}
