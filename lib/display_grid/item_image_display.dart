import 'dart:io';

import 'package:file_gallery/display_grid/file_display_entity.dart';
import 'package:file_gallery/gallery/image_gallery.dart';
import 'package:file_gallery/util/file_gallery_util.dart';
import 'package:flutter/material.dart';

class ItemImageDisplay extends StatefulWidget {

  ItemImageDisplay({
    this.entity
  });

  final FileDisplayEntity entity;

  @override
  State<StatefulWidget> createState() {
    return _ItemImageDisplayState();
  }

}

class _ItemImageDisplayState extends State<ItemImageDisplay> {

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
              getFileName(),
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
    var source = widget.entity.resource;
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
          return ImageGallery(resources: [widget.entity.resource]);
//          return ImageDisplay.file(file: widget.source);
        })
    );
  }

  /// fileName为null 则获取路径文件名称
  String getFileName() {
    var entity = widget.entity;
    if (entity != null) {
      bool nameNotEmpty = entity.fileName != null && entity.fileName.isNotEmpty;
      return nameNotEmpty ? entity.fileName : FileGalleryUtil.getFileName(entity.resource);
    }
    return '';
  }

}