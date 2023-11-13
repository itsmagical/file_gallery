import 'dart:io';

import 'package:file_gallery/gallery/image_gallery.dart';
import 'package:file_gallery/upload/file_upload_share_widget.dart';
import 'package:file_gallery/upload/upload_status/upload_status_controller.dart';
import 'package:file_gallery/upload/upload_status/upload_status_widget.dart';
import 'package:flutter/material.dart';

class ItemImageUpload<T> extends StatefulWidget {

  ItemImageUpload(
      this.source,
      {
        this.deleteCallback,
        this.retryingCallback,
        this.statusController
      }
  );

  final T source;

  final Function? deleteCallback;

  final VoidCallback? retryingCallback;
  final UploadStatusController? statusController;

  @override
  State<StatefulWidget> createState() {
    return _ItemImageUploadState();
  }

}

class _ItemImageUploadState extends State<ItemImageUpload> {

  FileUploadShareWidget get _shareWidget => FileUploadShareWidget.of(context);

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
                child: getImage(),
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

  Widget getImage() {
    var source = widget.source;
    if (source is File) {
      return Image.file(
        source,
        fit: BoxFit.cover,
      );
    } else if (source is String) {
      if (isNetworkSource(source)) {
        return Image.network(
          source,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          source,
          fit: BoxFit.cover,
        );
      }
    }

    return Container();
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
          return ImageGallery(resources: [widget.source]);
//          return ImageDisplay.file(file: widget.source);
        })
    );
  }

}