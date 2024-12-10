import 'package:alsan_app/data/network/api_client.dart';
import 'package:alsan_app/model/service.dart';
import 'package:alsan_app/model/time_of_day.dart';

import '../data/network/api_endpoints.dart';
import '../model/create_razor_pay.dart';
import '../model/mode_of_consultation.dart';
import '../model/reports.dart';
import '../model/session.dart';

class SessionRepo {
  Future<List<ModeOfConsultation>> getModeOfConsultation() async {
    var response = await apiClient.get(Api.modeOfConsultation);
    var list = response['consultations'] as List;
    return list.map((e) => ModeOfConsultation.fromMap(e)).toList();
  }

  Future<List<TimeOfDay>> getTimeSlots({query}) async {
    var response = await apiClient.get(Api.timeslots, query: query);
    var list = response as List;
    return list.map((e) => TimeOfDay.fromJson(e)).toList();
  }

  Future createSessions({body}) {
    return apiClient.post(Api.sessions, body);
  }

  Future<List<Session>> getSessions({query}) async {
    var response = await apiClient.get(
      Api.sessions,
      query: query,
    );
    var list = response['sessions'] as List;
    return list.map((e) => Session.fromMap(e)).toList();
  }

  Future<Session> getSessionById(String id) async {
    var response = await apiClient.get("${Api.sessions}/$id");
    return Session.fromMap(response);
  }

  Future updateSession({required String id, body}) {
    return apiClient.patch('${Api.updateSession}/$id', body);
  }

  Future joinSession({required query}) async {
    return await apiClient.get(Api.join, query: query);
  }

  Future postPaymentDetails({required num id, required body}) async {
    var response = await apiClient.post('${Api.payment}/$id', body);
    return response;
  }

  Future generateToken(String channel, int userId) async {
    return await apiClient.post(
      '${Api.sessions}/token',
      {"channel": channel, "userId": userId},
    );
  }

  Future postSessionFeedback({required num id, body}) {
    return apiClient.post('${Api.reviews}/$id', body);
  }

  Future<List<Report>> getSessionReports({
    required num id,
    required query,
  }) async {
    var res = await apiClient.get('${Api.reports}/$id', query: query);
    var list = res['data'] as List;
    return list.map((e) => Report.fromJson(e)).toList();
  }

  Future<List<String>> getPatientSymptoms() async {
    var res = await apiClient.get(Api.patients + Api.symptoms) as List;
    return res.map((e) => e as String).toList();
  }

  Future updateSessionClinician({required String id, required body}) {
    return apiClient.patch('${Api.sessionClinician}/$id', body);
  }

  Future postDuration({required body}) {
    return apiClient.post(Api.duration, body);
  }

  Future<CreateRazorPay> createRazorPayOrder({required body}) async {
    var res = await apiClient.post('${Api.payments}/create-order', body);
    return CreateRazorPay.fromJson(res);
  }

  Future verifyOrder({required body}) {
    return apiClient.post('${Api.payments}/verify-transaction', body);
  }

  Future<Services> getServices({required query}) async {
    var response = await apiClient.get(Api.services, query: query);
    return Services.fromJson(response);
  }

  Future<List<TimeOfDay>> getClinicianAvailableTimeSlots({
    required String id,
    required query,
  }) async {
    var response = await apiClient.get(
      '${Api.clinicians}/$id/available-time-slots',
      query: query,
    );
    var list = response as List;
    return list.map((e) => TimeOfDay.fromJson(e)).toList();
  }

  Future<Services> getClinicianServices({required String id}) async {
    var response = await apiClient.get('${Api.services}/${Api.clinicians}/$id');
    return Services.fromJson(response);
  }
}
