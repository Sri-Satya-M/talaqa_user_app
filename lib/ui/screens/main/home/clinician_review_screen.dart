import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/review.dart';
import '../../../../resources/strings.dart';
import '../../../widgets/loading_widget.dart';
import 'widgets/review_card.dart';

class ClinicianReviewsScreen extends StatefulWidget {
  final String id;

  const ClinicianReviewsScreen({super.key, required this.id});

  static Future open(BuildContext context, {required String id}) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ClinicianReviewsScreen(id: id)),
    );
  }

  @override
  State<ClinicianReviewsScreen> createState() => _ClinicianReviewsScreenState();
}

class _ClinicianReviewsScreenState extends State<ClinicianReviewsScreen> {
  bool state = false;

  bool isFinished = false;
  bool isLoading = false;
  List<Review> reviews = [];

  Future<void> fetchMore() async {
    if (isFinished || isLoading) return;
    isLoading = true;
    try {
      var limit = 20;
      var query = {
        'offset': reviews.length.toString(),
        'limit': limit.toString(),
      };

      var list = await context.read<UserBloc>().getReview(id: widget.id);
      reviews.addAll(list);

      if (list.length < limit) isFinished = true;
    } catch (e) {
      isFinished = true;
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.reviews))),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: reviews.length + ((isFinished) ? 0 : 1),
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          if (index == reviews.length) {
            fetchMore();
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const LoadingWidget(),
                    const SizedBox(height: 8),
                    Text(
                      'Fetching more Reviews',
                      style: textTheme.caption!.copyWith(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return ReviewCard(review: reviews[index]);
        },
      ),
    );
  }
}
