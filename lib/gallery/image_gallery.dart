
import 'dart:io';

import 'package:file_gallery/gallery/item_image_gallery.dart';
import 'package:file_gallery/util/file_type_util.dart';
import 'package:flutter/material.dart';



///
/// 图片预览列表
/// @author LiuHe
/// @created at 2021/3/3 15:40

class ImageGallery extends StatefulWidget {

  ImageGallery({
    required this.resources,
    this.index = 0
  });

  /// file、url、asset
  final List<dynamic> resources;

  /// 默认显示
  final int index;

  @override
  State<StatefulWidget> createState() {
    return _ImageGalleryState();
  }
}

class _ImageGalleryState extends State<ImageGallery> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: PageView.builder(
              controller: PageController(initialPage: widget.index),
              itemBuilder: (context, index) {
                for (int i = 0; i < widget.resources.length; i++) {
                  var resource = widget.resources[i];
                  if (FileTypeUtil.isImage(resource)) {
                    return getImageDisplay(resource);
                  }
                }

                return Container(
                  child: Text('不支持此类型文件'),
                );
              },
              itemCount: widget.resources.length,
            ),
          ),

          Wrap(
            children: <Widget>[
              AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 加载不同图片资源
  Widget getImageDisplay(var resource) {
    if (resource is File) {
      return ItemImageGallery.file(file: resource);
    } else {
      if (resource is String) {
        return FileTypeUtil.isNetworkSource(resource)
            ? ItemImageGallery.url(url: resource)
            : ItemImageGallery.asset(asset: resource);
      }
    }
    return Container(
      child: Text('不支持的图片类型'),
    );
  }

}