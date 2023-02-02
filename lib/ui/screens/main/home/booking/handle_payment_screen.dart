import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/ui/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/session.dart';
import '../../../../widgets/success_screen.dart';

class HandlePaymentScreen extends StatefulWidget {
  final Session session;
  final dynamic transactionDetails;

  const HandlePaymentScreen(
      {super.key, required this.session, required this.transactionDetails});

  static Future open(
    BuildContext context, {
    required Session session,
    required dynamic transactionDetails,
  }) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HandlePaymentScreen(
          session: session,
          transactionDetails: transactionDetails,
        ),
      ),
      (route) => false,
    );
  }

  @override
  _HandlePaymentScreenState createState() => _HandlePaymentScreenState();
}

class _HandlePaymentScreenState extends State<HandlePaymentScreen> {
  @override
  void initState() {
    super.initState();
    handlePayment();
  }

  handlePayment() async {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    var response = await sessionBloc.updateSession(
      body: {
        "id": widget.session.id,
        "status": "PAID",
        "paymentDetails": widget.transactionDetails,
        "paymentJson": widget.transactionDetails.toString()
      },
    ) as Map<String, dynamic>;
    if (response.containsKey('status') && response['status'] == 'success') {
      SuccessScreen.open(
        context,
        type: 'Payment',
        message: 'Paid ${widget.session.totalAmount!} Rupee Successfully',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Your Payment is being processed'),
          SizedBox(height: 24),
          LoadingWidget(),
        ],
      ),
    );
  }
}
