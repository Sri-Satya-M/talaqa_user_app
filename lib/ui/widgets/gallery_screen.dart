import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'loading_widget.dart';

class GalleryScreen extends StatefulWidget {
  final List<String> images;
  final int index;

  const GalleryScreen({
    Key? key,
    required this.images,
    required this.index,
  }) : super(key: key);

  static Future open(BuildContext context, List<String> images, int index) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GalleryScreen(images: images, index: index),
      ),
    );
  }

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  PageController? ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      behavior: HitTestBehavior.opaque,
      direction: DismissDirection.down,
      onDismissed: (v) => Navigator.pop(context, true),
      key: const Key(''),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned(
              child: PhotoViewGallery.builder(
                pageController: ctrl,
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(
                      widget.images[index],
                      maxHeight: 2000,
                      maxWidth: 1000,
                    ),
                    initialScale: PhotoViewComputedScale.contained * 0.95,
                    maxScale: PhotoViewComputedScale.contained * 3.0,
                    minScale: PhotoViewComputedScale.contained * 0.7,
                  );
                },
                itemCount: widget.images.length,
                loadingBuilder: (context, event) => const LoadingWidget(),
              ),
            ),
            Positioned(
              top: 0,
              left: 8,
              child: SafeArea(
                child: CircleAvatar(
                  backgroundColor: Colors.black12,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
