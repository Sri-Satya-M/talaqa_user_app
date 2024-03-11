// import 'package:flutter/material.dart';
// import 'package:moment_dart/moment_dart.dart';
//
// import '../../../../../model/review.dart';
// import '../../../../../resources/colors.dart';
// import '../../../../widgets/avatar.dart';
// import '../../../../widgets/custom_card.dart';
// import '../../../../widgets/details_tile.dart';
//
// class ReviewCard extends StatelessWidget {
//   final Review review;
//
//   const ReviewCard({super.key, required this.review});
//
//   @override
//   Widget build(BuildContext context) {
//     var textTheme = Theme.of(context).textTheme;
//     var moment = Moment.now().from(review.createdAt!);
//     return CustomCard(
//       radius: 4,
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Avatar(
//                   url: review.patient?.imageUrl,
//                   name: review.patient!.user!.fullName!,
//                   borderRadius: BorderRadius.circular(20),
//                   size: 40,
//                 ),
//                 const SizedBox(width: 16),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     DetailsTile(
//                       title: Text(
//                         review.patient!.user!.fullName!,
//                         style: textTheme.bodyMedium,
//                       ),
//                       value: Text(moment, style: textTheme.bodySmall),
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     color: MyColors.primaryColor.withOpacity(0.2),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.star,
//                         size: 14,
//                         color: MyColors.primaryColor,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         review.rating.toString(),
//                         style: textTheme.bodyLarge,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               '${review.comment}',
//               maxLines: 3,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
