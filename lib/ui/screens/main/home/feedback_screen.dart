import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/ui/screens/main/home/widgets/feedback_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';
import 'package:alsan_app/model/feedback.dart' as f;

class FeedbackScreen extends StatelessWidget {
  final String id;

  const FeedbackScreen({super.key, required this.id});

  static Future open(BuildContext context, {required String id}) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FeedbackScreen(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: FutureBuilder<List<f.Feedback>>(
        future: userBloc.getFeedback(id: id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }

          if (!snapshot.hasData) return const LoadingWidget();

          var feedbackList = snapshot.data ?? [];

          if (feedbackList.isEmpty) return const EmptyWidget();

          return ListView.builder(
            shrinkWrap: true,
            itemCount: feedbackList.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              return FeedbackCard(feedback: feedbackList[index]);
            },
          );
        },
      ),
    );
  }
}
