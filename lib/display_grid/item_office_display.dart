import 'dart:io';

import 'package:file_gallery/display_grid/file_display_entity.dart';
import 'package:file_gallery/gallery/office_display.dart';
import 'package:file_gallery/images/file_gallery_images.dart';
import 'package:file_gallery/util/file_gallery_util.dart';
import 'package:file_gallery/util/file_type_util.dart';
import 'package:flutter/material.dart';

class ItemOfficeDisplay extends StatefulWidget {

  ItemOfficeDisplay({
    this.entity
  });

  final FileDisplayEntity entity;

  @override
  State<StatefulWidget> createState() {
    return _ItemOfficeDisplayState();
  }

}

class _ItemOfficeDisplayState extends State<ItemOfficeDisplay> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        displayImage();
      },
      child: Container(
//        color: Colors.red,
        child: Column(
          children: <Widget>[
            Expanded(child: Image.asset(getThumbnail())),
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
      ),
    );
  }

  String getThumbnail() {
    var resource = widget.entity.resource;

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

  /// 预览图片
  displayImage() {

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          var resource = widget.entity.resource;
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