import 'dart:io';

import 'package:file_gallery/gallery/office_display.dart';
import 'package:file_gallery/images/file_gallery_images.dart';
import 'package:file_gallery/util/file_type_util.dart';
import 'package:flutter/material.dart';

/// 文件上传grid office item
class ItemOfficeUpload<T> extends StatefulWidget {

  ItemOfficeUpload(
      this.source,
      {
        this.deleteCallback,
      }
  );

  final T source;

  final Function deleteCallback;

  @override
  State<StatefulWidget> createState() {
    return _ItemOfficeUploadState();
  }

}

class _ItemOfficeUploadState extends State<ItemOfficeUpload> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        displayOfficeFile();
      },
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Container(
              child: Image.asset(getThumbnail()),
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () {
                widget.deleteCallback();
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
          )
        ],
      ),
    );
  }

  String getThumbnail() {
    var resource = widget.source;

    if (FileTypeUtil.isWord(resource)) {
      return FileGalleryImages.file_type_word;
    }

    if (FileTypeUtil.isExcel(resource)) {
      return FileGalleryImages.file_type_excel;
    }

    if (FileTypeUtil.isPPT(resource)) {
      return FileGalleryImages.file_type_ppt;
    }

    if (FileTypeUtil.isPDF(resource)) {
      return FileGalleryImages.file_type_pdf;
    }

    if (FileTypeUtil.isTxt(resource)) {
      return FileGalleryImages.file_type_txt;
    }

    return FileGalleryImages.file_type_unknown;

  }

  /// 是否为网络资源
  bool isNetworkSource(path) {
    return path.contains('http://') || path.contains('https://');
  }

  /// 预览文件
  displayOfficeFile() {

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          var resource = widget.source;
          if (resource is File) {
            return OfficeDisplay.file(file: resource);
          } else if (resource is String) {
            return OfficeDisplay.url(url: resource);
          }
          return Container(
            child: Text('无效类型'),
          );
        })
    );
  }

}