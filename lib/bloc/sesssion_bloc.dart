import 'dart:async';
import 'dart:convert';

import 'package:alsan_app/model/environment.dart';
import 'package:alsan_app/model/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../model/address.dart';
import '../model/chat.dart';
import '../model/clinicians.dart';
import '../model/create_razor_pay.dart';
import '../model/mode_of_consultation.dart';
import '../model/profile.dart';
import '../model/reports.dart';
import '../model/session.dart';
import '../model/time_of_day.dart';
import '../repository/session_repo.dart';
import '../resources/images.dart';

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
  int? selectedStatement;
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

  clear() {
    selectedPatient = null;
    service = null;
    symptom = null;
    selectedModeOfConsultation = null;
    selectedDate = null;
    selectedTimeSlotIds?.clear();
    description = null;
    selectedClinician = null;
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

  Future postPaymentDetails({required int id, required body}) async {
    return await sessionRepo.postPaymentDetails(id: id, body: body);
  }

  Future joinSession({required query}) async {
    return await sessionRepo.joinSession(query: query);
  }

  Future generateToken(String channel, int userId) {
    return sessionRepo.generateToken(channel, userId);
  }

  Future postSessionFeedback({required int id, body}) {
    return sessionRepo.postSessionFeedback(id: id, body: body);
  }

  Future<List<Report>> getSessionReports({required int id}) {
    return sessionRepo.getSessionReports(id: id);
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

  Future createRazorPayOrder({required Session session}) async {
    var order = await sessionRepo.createRazorPayOrder(
      body: {"sessionId": session.id},
    );

    var response = await executeRazorPay(order: order, session: session);

    var body = {};

    body['rzpOrderId'] = response.orderId;
    body['rzpPaymentId'] = response.paymentId;
    body['rzpSignature'] = response.signature;

    var verifyResponse = await sessionRepo.verifyOrder(body: body);
    clear();

    return verifyResponse;
  }

  Completer<PaymentSuccessResponse>? razorpayCompleter;

  executeRazorPay({
    required CreateRazorPay order,
    required Session session,
  }) async {
    print(Environment.razorPayKey);
    var options = {
      'order_id': order.rzpOrderId,
      'key': Environment.razorPayKey,
      'amount': order.rzpOrderAmount,
      'currency': 'INR',
      'name': 'Talaqa',
      'description': 'Online Session Booking Payment',
      'image': Images.logo,
      'prefill': {
        'contact': session.patient!.user!.mobileNumber!,
        'email': session.patient!.user!.email!,
      },
      "theme": {"color": "#02283D"}
    };

    var _razorpay = Razorpay();
    razorpayCompleter = Completer();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) {
      razorpayCompleter!.complete(response);
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) {
      print('Razorpay error : ${response.code}, ${response.message}');
      try {
        var error = jsonDecode(response.message ?? '')['error']['description'];
        razorpayCompleter!.completeError(error);
      } catch (e) {
        print(e);
        razorpayCompleter!.completeError('Something went wrong');
      }
    });

    _razorpay.open(options);

    var response = await razorpayCompleter!.future;
    _razorpay.clear();

    return response;
  }

  Future<Services> getServices({required query}) {
    return sessionRepo.getServices(query: query);
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
