import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/resources.dart';
import 'package:alsan_app/ui/screens/main/resources/play_video_screen.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/image_from_net.dart';
import '../../../widgets/loading_widget.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();

  static void open(BuildContext context, String link) {}
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return FutureBuilder<List<Resources>>(
      future: userBloc.getResources(query: {'type': "VIDEO"}),
      builder: (context, snapshot) {
        if (snapshot.hasError) return CustomErrorWidget(error: snapshot.error);
        if (!snapshot.hasData) return const LoadingWidget();
        var resources = snapshot.data ?? [];
        if (resources.isEmpty) return const EmptyWidget();
        return ListView.builder(
          itemCount: resources.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                PlayVideoScreen.open(context, link: resources[index].link);
              },
              child: Container(
                margin: const EdgeInsets.all(20),
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
                      gap: 15,
                      title: Text(resources[index].title),
                      value: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Updated on ${DateFormat('dd MMM, yyyy').format(resources[index].updatedAt)}',
                            style: textTheme.caption,
                          ),
                          const Icon(Icons.share, size: 18)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
