import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryViewer extends StatefulWidget {
  GalleryViewer({Key? key, required this.images, this.index = 0})
      : pageController = PageController(initialPage: index);

  final images;
  final index;
  final PageController pageController;

  @override
  State<GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer> {
  late int index = widget.index;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: PhotoViewGallery.builder(
          pageController: widget.pageController,
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            final image = widget.images[index];
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(image),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 4,
              heroAttributes: PhotoViewHeroAttributes(tag: index),
            );
          },
          onPageChanged: (index) => setState(() => this.index = index),
          itemCount: widget.images.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
        ));
  }
}
