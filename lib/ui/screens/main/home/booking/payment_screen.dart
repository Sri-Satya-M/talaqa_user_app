import 'dart:async';
import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/model/environment.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/error_screen.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkLocale.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:provider/provider.dart';

import '../../../../../model/session.dart';
import '../../../../../resources/images.dart';
import '../../../../../resources/strings.dart';
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
      profileId: Environment.profileId,
      serverKey: Environment.serverKey,
      clientKey: Environment.clientKey,
      cartId: "${widget.session.sessionId}",
      cartDescription: "${widget.session.sessionId}",
      merchantName: Environment.merchantName,
      screentTitle: "Pay with Card",
      amount: widget.session.totalAmount!.toDouble(),
      locale: PaymentSdkLocale.EN,
      currencyCode: Environment.currencyCode,
      merchantCountryCode: Environment.merchantCountryCode,
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
      "yashwanth@janaspandana.in",
      "+917702165416",
      "${widget.session.patientAddress?.addressLine1 ?? 'Road 16'}",
      "IN",
      "${widget.session.patientAddress?.city ?? "Hyderabad"}",
      "${widget.session.patientAddress?.country ?? "IN"}",
      "${widget.session.patientAddress?.pincode ?? "500089"}",
    );
    print(
        'billingDetails: \n${billingDetails.name} \n${billingDetails.email} \n${billingDetails.phone} \n${billingDetails.addressLine} \n${billingDetails.country} \n${billingDetails.city} \n${billingDetails.state} \n${billingDetails.zipCode}');
  }

  var list = [
    {"title": 'Pay with Card', "value": 0},
    {"title": 'Pay with Saved Card', "value": 1}
  ];

  void onTap(int value) async {
    if (widget.session.patient?.user?.mobileNumber == null ||
        widget.session.patientAddress?.id == null ||
        widget.session.patient?.user?.email == null) {
      return ErrorSnackBar.show(
        context,
        'Kindly update mobile number, email, address to completed payment',
      );
    }
    switch (value) {
      case 0:
        ProgressUtils.handleProgress(context, task: () async {
          payPressed();
        });

        break;
      case 1:
        payWithSavedCards();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(langBloc.getString(Strings.selectPaymentMethod)),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return CustomCard(
            child: InkWell(
              onTap: () async => onTap.call(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                child: Row(
                  children: [
                    DetailsTile(
                      title: Image.asset(Images.card, height: 25),
                      gap: 16,
                      value: Text(
                        langBloc.getString(Strings.payWithCard),
                        style: textTheme.bodyText2?.copyWith(fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
