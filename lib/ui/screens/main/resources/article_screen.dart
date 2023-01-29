import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/resources.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/image_from_net.dart';
import 'package:alsan_app/ui/widgets/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';

class ArticleScreen extends StatefulWidget {
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return FutureBuilder<List<Resources>>(
        future: userBloc.getResources(query: {'type': 'ARTICLE'}),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }
          if (!snapshot.hasData) return const LoadingWidget();
          var resources = snapshot.data ?? [];
          if (resources.isEmpty) return const EmptyWidget();
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: resources.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: InkWell(
                  onTap: () {
                    WebviewScreen.open(
                      context,
                      url: resources[index].link!,
                      title: resources[index].title!,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.black.withOpacity(0.05),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 150,
                          width: double.maxFinite,
                          child: ImageFromNet(
                            imageUrl: resources[index].thumbnail,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        DetailsTile(
                          padding: const EdgeInsets.all(15),
                          gap: 8,
                          title: Text(resources[index].title!),
                          value: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                resources[index].description!,
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
                ),
              );
            },
          );
        });
  }
}
