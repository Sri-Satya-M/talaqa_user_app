import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:flutter/material.dart';

class ArticleScreen extends StatefulWidget {
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black.withOpacity(0.05),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(Images.articleImage),
                DetailsTile(
                  padding: const EdgeInsets.all(15),
                  gap: 8,
                  title: const Text(
                    "What you should know about speech delay in children?",
                  ),
                  value: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Speech delay is when a child isn't developing speech and language at an expected rate. It refers to a delay in theSpeech delay is when a child isn't developing speech and language at an expected rate. It refers to a delay in the",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: textTheme.caption,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Read more",
                        style: TextStyle(color: MyColors.primaryColor),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
