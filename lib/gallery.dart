import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Gallery extends StatefulWidget {
  final List<String> urlImages;
  final int index;
  final PageController pageController;
  final Axis scrollDirection;

  Gallery({
    super.key,
    required this.urlImages,
    this.scrollDirection = Axis.horizontal,
    required this.index,
  }) : pageController = PageController(initialPage: index);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late int currentIndex = widget.index;

  @override
  void initState() {
    super.initState();
  }

  /// update ui header when user swipe
  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          '${currentIndex + 1} / ${widget.urlImages.length}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
            // back button here
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            // create the gallery itself
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              scrollDirection: widget.scrollDirection,
              pageController: widget.pageController,
              itemCount: widget.urlImages.length,
              backgroundDecoration: const BoxDecoration(color: Colors.white70),
              onPageChanged: _onPageChanged,
              builder: _buildItem,
            ),
          ),
        ],
      ),
    );
  }

  // PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
  //   final String item = widget.urlImages[index];
  //   return PhotoViewGalleryPageOptions(
  //     imageProvider: NetworkImage(item), // we are using url so NetworkImage
  //     initialScale: PhotoViewComputedScale.contained,
  //     minScale: PhotoViewComputedScale.contained,
  //     maxScale: PhotoViewComputedScale.covered,
  //     heroAttributes: PhotoViewHeroAttributes(tag: item),
  //   );
  // }
  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.urlImages[index];
    return PhotoViewGalleryPageOptions(
      imageProvider:
          CachedNetworkImageProvider(item), // Use CachedNetworkImageProvider
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
  }
}
