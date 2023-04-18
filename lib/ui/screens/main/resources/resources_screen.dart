import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:alsan_app/ui/screens/main/resources/article_screen.dart';
import 'package:alsan_app/ui/screens/main/resources/videos_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  _ResourcesScreenState createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  @override
  Widget build(BuildContext context) {
    var mainBloc = Provider.of<MainBloc>(context, listen: true);
    return Builder(
      builder: (context) {
        switch (mainBloc.tab) {
          case 0:
            return const ArticleScreen();
          case 1:
            return const VideoScreen();
          default:
            return const SizedBox();
        }
      },
    );
  }
}
