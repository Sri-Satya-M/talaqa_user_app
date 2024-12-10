import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/resources.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/image_from_net.dart';
import 'package:alsan_app/ui/widgets/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../resources/strings.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/loading_widget.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool isFinished = false;
  bool isLoading = false;
  bool isEmpty = false;
  List<Resources> resources = [];

  Future<void> fetchMore() async {
    var userBloc = Provider.of<UserBloc>(context, listen: false);

    if (isFinished || isLoading) return;
    isLoading = true;
    try {
      var limit = 20;
      var query = {
        'type': 'ARTICLE',
        'offset': resources.length.toString(),
        'limit': limit.toString(),
      };

      var list = await userBloc.getResources(query: query);
      resources.addAll(list);

      if (list.length < limit) isFinished = true;
    } catch (e) {
      isFinished = true;
    }
    isLoading = false;
    isEmpty = resources.isEmpty;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: (isEmpty)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmptyWidget(
                  message: langBloc.getString(
                    Strings.articlesNotAvailableAtTheMoment,
                  ),
                ),
              ],
            )
          : CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == resources.length) {
                        fetchMore();
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const LoadingWidget(),
                                const SizedBox(height: 8),
                                Text(
                                  langBloc.getString(Strings.fetchingArticles),
                                  style: textTheme.bodySmall!.copyWith(
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: InkWell(
                          onTap: () {
                            WebViewScreen.open(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        resources[index].description!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: textTheme.bodySmall,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        langBloc.getString(Strings.readMore),
                                        style: const TextStyle(
                                          color: MyColors.primaryColor,
                                        ),
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
                    childCount: resources.length + (isFinished ? 0 : 1),
                  ),
                ),
              ],
            ),
    );
  }
}
