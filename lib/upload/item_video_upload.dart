import 'dart:io';

import 'package:file_gallery/images/file_gallery_images.dart';
import 'package:file_gallery/upload/file_upload_share_widget.dart';
import 'package:file_gallery/upload/upload_status/upload_status_controller.dart';
import 'package:file_gallery/upload/upload_status/upload_status_widget.dart';
import 'package:file_gallery/util/file_type_util.dart';
import 'package:file_gallery/video_player/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class ItemVideoUpload<T> extends StatefulWidget {

  ItemVideoUpload(
      this.source,
      {
        this.deleteCallback,
        this.retryingCallback,
        this.statusController,
        Key? key
      }
  );
//      : super(key: key);

  /// File or url
  final T source;

  final Function? deleteCallback;
  final VoidCallback? retryingCallback;
  final UploadStatusController? statusController;

  @override
  State<StatefulWidget> createState() {
    return _ItemVideoUploadState();
  }

}

class _ItemVideoUploadState extends State<ItemVideoUpload> {

  late VideoPlayerController _videoController;

  FileUploadShareWidget get _shareWidget => FileUploadShareWidget.of(context);

  @override
  void initState() {
    if (widget.source is File) {
      _videoController = VideoPlayerController.file(widget.source);
    } else if (widget.source is String) {
      if (isNetworkSource(widget.source))
        _videoController = VideoPlayerController.networkUrl(widget.source);
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
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Container(
              child: UploadStatusWidget(
                retryingCallback: widget.retryingCallback,
                statusController: widget.statusController,
                child: VideoPlayer(_videoController)),
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
          Visibility(
            visible: !_shareWidget.viewOnly!,
            child: Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () {
                  if (widget.deleteCallback != null) {
                    widget.deleteCallback!();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                  ),
                ),
              ),
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
          return getVideoWidget(widget.source);
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

}