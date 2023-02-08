import 'dart:async';
import 'package:alsan_app/ui/widgets/error_screen.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkLocale.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';

import '../../../../../model/session.dart';
import '../../../../../resources/images.dart';
import 'handle_payment_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Session session;

  const PaymentScreen({super.key, required this.session});

  static Future open(BuildContext context, {required Session session}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentScreen(session: session),
      ),
    );
  }

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late BillingDetails billingDetails;
  String _instructions = 'Tap on "Pay" Button to try PayTabs plugin';

  @override
  void initState() {
    super.initState();
  }

  PaymentSdkConfigurationDetails generateConfig() {
    List<PaymentSdkAPms> apms = [
      PaymentSdkAPms.KNET_CREDIT,
      PaymentSdkAPms.KNET_DEBIT
    ];

    var configuration = PaymentSdkConfigurationDetails(
      profileId: "something",
      serverKey: "",
      clientKey: "",
      cartId: "${widget.session.sessionId}",
      cartDescription: "${widget.session.sessionId}",
      merchantName: "",
      screentTitle: "Pay with Card",
      amount: widget.session.totalAmount!.toDouble(),
      locale: PaymentSdkLocale.EN,
      currencyCode: "INR",
      merchantCountryCode: "IN",
      billingDetails: billingDetails,
      alternativePaymentMethods: apms,
      linkBillingNameWithCardHolderName: false,
    );

    var theme = IOSThemeConfigurations();

    theme.logoImage = Images.logo;
    theme.secondaryColor = "FBF2F2";
    theme.titleFontColor = "191919";
    theme.backgroundColor = "FFFFFF";
    theme.primaryColor = "FFFFFF";
    theme.secondaryFontColor = "0052CC";
    theme.primaryFontColor = "FFFFFF";
    theme.buttonColor = "0052CC";
    theme.placeholderColor = "000000";
    configuration.iOSThemeConfigurations = theme;

    // configuration.tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
    // configuration.tokenFormat = PaymentSdkTokenFormat.AlphaNum20Format;
    return configuration;
  }

  Future<void> payPressed() async {
    getBillingDetails();
    setState(() {
      FlutterPaytabsBridge.startCardPayment(generateConfig(), (event) async {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          // print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            HandlePaymentScreen.open(
              context,
              session: widget.session,
              transactionDetails: transactionDetails,
            );
          }
        } else if (event["status"] == "error") {
          // Handle error here.
          ErrorScreen.open(context, message: "Payment Failed");
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Future<void> payWithSavedCards() async {
    FlutterPaytabsBridge.startPaymentWithSavedCards(generateConfig(), false,
        (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            print("successful transaction");
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            print("failed transaction");
          }

          // print(transactionDetails["isSuccess"]);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  void getBillingDetails() {
    billingDetails = BillingDetails(
      "${widget.session.patientProfile!.fullName}",
      "",
      "",
      "${widget.session.patientAddress?.addressLine1??'Road 16'}",
      "IN",
      "${widget.session.patientAddress?.city?? "Hyderabad"}",
      "${widget.session.patientAddress?.country??"IN"}",
      "${widget.session.patientAddress?.pincode?? "500089"}",
    );
    print(
        'billingDetails: \n${billingDetails.name} \n${billingDetails.email} \n${billingDetails.phone} \n${billingDetails.addressLine} \n${billingDetails.country} \n${billingDetails.city} \n${billingDetails.state} \n${billingDetails.zipCode}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayTabs Plugin Example App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$_instructions'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                ProgressUtils.handleProgress(context, task: () async {
                  payPressed();
                });
              },
              child: Text('Pay with Card'),
            ),
            TextButton(
              onPressed: () async {
                payWithSavedCards();
              },
              child: Text('Pay with saved cards'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
