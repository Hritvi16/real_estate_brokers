import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';

class PhotoView extends StatefulWidget {
  final List<Images> images;
  const PhotoView({Key? key, required this.images}) : super(key: key);

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  late List<Images> images;
  @override
  void initState() {
    images = widget.images;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(
            Environment.propertyUrl + (images?[index].image ?? "")
          ),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
        );
      },
      itemCount: images.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes??0),
          ),
        ),
      ),
    );
  }
}
