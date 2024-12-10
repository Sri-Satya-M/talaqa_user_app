import 'package:amazon_payfort/amazon_payfort.dart';
import 'package:flutter/cupertino.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../model/payfort_token_response.dart';
import '../model/session.dart';
import '../repository/payment_repo.dart';
import '../utils/payfort_constants.dart';

class PaymentBloc with ChangeNotifier {
  final AmazonPayfort _payfort = AmazonPayfort.instance;

  final NetworkInfo _info = NetworkInfo();

  Future<void> init() async {
    await AmazonPayfort.initialize(
      const PayFortOptions(environment: PayfortConstants.environment),
    );
  }

  Future<PayfortTokenResponse?> _generateSdkToken() async {
    var accessCode = PayfortConstants.accessCode;
    var shaRequestPhrase = PayfortConstants.shaRequestPhrase;
    String? deviceId = await _payfort.getDeviceId();

    SdkTokenRequest tokenRequest = SdkTokenRequest(
      accessCode: accessCode,
      deviceId: deviceId ?? '',
      merchantIdentifier: PayfortConstants.merchantIdentifier,
    );

    String? signature = await _payfort.generateSignature(
      shaType: PayfortConstants.shaType,
      concatenatedString: tokenRequest.toConcatenatedString(shaRequestPhrase),
    );

    tokenRequest = tokenRequest.copyWith(signature: signature);

    return await PaymentRepo.generateSdkToken(tokenRequest);
  }

  Future<void> paymentWithCreditOrDebitCard({
    required SucceededCallback onSucceeded,
    required FailedCallback onFailed,
    required CancelledCallback onCancelled,
    required Session session,
  }) async {
    try {
      PayfortTokenResponse? sdkTokenResponse = await _generateSdkToken();

      if (sdkTokenResponse != null && sdkTokenResponse.sdkToken == null) {
        return onFailed(
          PayFortFailureResult(message: sdkTokenResponse.responseMessage ?? ''),
        );
      }

      if (session.sessionPayment?.totalAmount == null ||
          (session.sessionPayment?.totalAmount ?? 0) < 10) {
        return onFailed(
          const PayFortFailureResult(message: 'Session amount is undefined'),
        );
      }

      FortRequest request = FortRequest(
        command: FortCommand.authorization,
        amount: (session.sessionPayment?.totalAmount ?? 0) * 100,
        customerName: session.patient?.user?.fullName ?? 'NA',
        customerEmail: session.patient?.user?.email ?? 'NA',
        orderDescription: 'Order',
        sdkToken: '${sdkTokenResponse?.sdkToken}',
        merchantReference: const Uuid().v4(),
        currency: 'SAR',
        customerIp: (await _info.getWifiIP() ?? ''),
      );

      _payfort.callPayFort(
        request: request,
        callBack: PayFortResultCallback(
          onSucceeded: onSucceeded,
          onFailed: onFailed,
          onCancelled: onCancelled,
        ),
      );
    } catch (e) {
      onFailed(PayFortFailureResult(message: e.toString()));
    }
  }
}
