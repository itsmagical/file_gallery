import 'dart:io';

import 'package:file_gallery/gallery/image_gallery.dart';
import 'package:file_gallery/util/file_gallery_util.dart';
import 'package:flutter/material.dart';

class ItemImageThumbnail extends StatefulWidget {

  ItemImageThumbnail({
    this.resource
  });

  final dynamic resource;

  @override
  State<StatefulWidget> createState() {
    return _ItemImageThumbnailState();
  }

}

class _ItemImageThumbnailState extends State<ItemImageThumbnail> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        displayImage();
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: getImage(),
            ),
          ),
          Container(
            height: 20,
            alignment: Alignment.center,
            child: Text(
              FileGalleryUtil.getFileName(widget.resource),
              style: TextStyle(
                  fontSize: 12
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  Widget getImage() {
    var source = widget.resource;
    if (source is File) {
      return Image.file(
        source,
//        fit: BoxFit.cover,
      );
    } else if (source is String) {
      if (isNetworkSource(source)) {
        return Image.network(
          source,
//          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          source,
//          fit: BoxFit.cover,
        );
      }
    }

    return null;
  }

  /// 是否为网络资源
  bool isNetworkSource(path) {
    return path.contains('http://') || path.contains('https://');
  }

  /// 预览图片
  displayImage() {

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ImageGallery(resources: [widget.resource]);
//          return ImageDisplay.file(file: widget.source);
        })
    );
  }

}