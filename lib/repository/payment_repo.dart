import 'dart:convert';

import 'package:amazon_payfort/amazon_payfort.dart';
import 'package:http/http.dart';

import '../model/payfort_token_response.dart';
import '../utils/payfort_constants.dart';

class PaymentRepo {
  static Future<PayfortTokenResponse?> generateSdkToken(
    SdkTokenRequest request,
  ) async {
    var response = await post(
      Uri.parse(PayfortConstants.environment.paymentApi),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.asRequest()),
    );
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      return PayfortTokenResponse.fromMap(decodedResponse);
    }
    return null;
  }
}
