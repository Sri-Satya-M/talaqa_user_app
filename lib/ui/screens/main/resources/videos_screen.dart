import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/resources.dart';
import 'package:alsan_app/ui/screens/main/resources/play_video_screen.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../resources/strings.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/image_from_net.dart';
import '../../../widgets/loading_widget.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool isFinished = false;
  bool isLoading = false;
  bool isEmpty = false;
  List<Resources> videos = [];

  Future<void> fetchMore() async {
    var userBloc = Provider.of<UserBloc>(context, listen: false);

    if (isFinished || isLoading) return;
    isLoading = true;
    try {
      var limit = 20;
      var query = {
        'type': "VIDEO",
        'offset': videos.length.toString(),
        'limit': limit.toString(),
      };

      var list = await userBloc.getResources(query: query);
      videos.addAll(list);

      if (list.length < limit) isFinished = true;
    } catch (e) {
      isFinished = true;
    }
    isLoading = false;
    isEmpty = videos.isEmpty;
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
                    Strings.videosNotAvailableAtTheMoment,
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
                      if (index == videos.length) {
                        fetchMore();
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const LoadingWidget(),
                                const SizedBox(height: 8),
                                Text(
                                  langBloc.getString(Strings.fetchingVideos),
                                  style: textTheme.bodySmall!.copyWith(
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          PlayVideoScreen.open(
                            context,
                            resource: videos[index],
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 2,
                              color: Colors.black.withOpacity(0.05),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 150,
                                width: double.maxFinite,
                                child: ImageFromNet(
                                  imageUrl: videos[index].thumbnail,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              DetailsTile(
                                padding: const EdgeInsets.all(15),
                                gap: 15,
                                title: Text(videos[index].title!),
                                value: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${langBloc.getString(Strings.updatedOn)} ${DateFormat('dd MMM, yyyy').format(videos[index].updatedAt!)}',
                                      style: textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: videos.length + (isFinished ? 0 : 1),
                  ),
                ),
              ],
            ),
    );
  }
}
