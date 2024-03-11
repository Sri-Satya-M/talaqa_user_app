import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../../resources/colors.dart';

class RatingWidget extends StatefulWidget {
  final Function(double) onTap;

  const RatingWidget({super.key, required this.onTap});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double? rating;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
          color: MyColors.divider,
          border: Border.all(color: const Color(0xFF0D0D0D1A)),
          borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: 300,
            child: Text(
              "Rate your experience",
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          RatingBar.builder(
            initialRating: 0,
            minRating: 0,
            direction: Axis.horizontal,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Color(0xFF1268AE),
              size: 18,
            ),
            onRatingUpdate: (rating) {
              this.rating = rating;
              widget.onTap.call(rating);
              setState(() {});
            },
          ),
          const SizedBox(height: 8),
          Text(getRatingTitle()),
        ],
      ),
    );
  }

  getRatingTitle() {
    if (rating == null) return '';
    switch (rating!.toInt()) {
      case 1:
        return "Poor";
      case 2:
        return "Bad";
      case 3:
        return "Good";
      case 4:
        return "Better";
      case 5:
        return "Excellent";
    }
  }
}
