import 'dart:io';

import 'package:file_gallery/display_grid/file_display_entity.dart';
import 'package:file_gallery/images/file_gallery_images.dart';
import 'package:file_gallery/util/file_gallery_util.dart';
import 'package:file_gallery/util/file_type_util.dart';
import 'package:file_gallery/video_player/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class ItemVideoDisplay extends StatefulWidget {

  ItemVideoDisplay({
    required this.entity
  });

  /// File or url
  final FileDisplayEntity entity;

  @override
  State<StatefulWidget> createState() {
    return _ItemVideoDisplayState();
  }

}

class _ItemVideoDisplayState extends State<ItemVideoDisplay> {

  late VideoPlayerController _videoController;

  @override
  void initState() {
    var resource = widget.entity.resource;
    if (resource is File) {
      _videoController = VideoPlayerController.file(resource);
    } else if (resource is String) {
      if (isNetworkSource(resource))
        _videoController = VideoPlayerController.network(resource);
    }
    _videoController.initialize().then((value) {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        displayImage();
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    child: VideoPlayer(_videoController),
                  ),
                ),
                Center(
                  child: Container(
                    child: Image.asset(
                      FileGalleryImages.video_player_start,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ],
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

  /// 是否为网络资源
  bool isNetworkSource(path) {
    return path.contains('http://') || path.contains('https://');
  }

  /// 预览视频
  displayImage() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return getVideoWidget(widget.entity.resource);
          // return FileDisplay(resources: [widget.source]);
        })
    );

  }

  /// 加载不同视频资源
  Widget getVideoWidget(var resource) {
    if (resource is File) {
      return VideoPlayerWidget.file(file: resource);
    } else {
      if (resource is String) {
        return FileTypeUtil.isNetworkSource(resource)
            ? VideoPlayerWidget.url(url: resource)
            : VideoPlayerWidget.asset(asset: resource);
      }
    }
    return Container(
      child: Text('不支持的图片类型'),
    );
  }

  /// fileName为null 则获取路径文件名称
  String getFileName() {
    var entity = widget.entity;
    if (entity != null && entity.fileName != null) {
      bool nameNotEmpty = entity.fileName != null && entity.fileName!.isNotEmpty;
      return nameNotEmpty ? entity.fileName! : FileGalleryUtil.getFileName(entity.resource);
    }
    return '';
  }

}