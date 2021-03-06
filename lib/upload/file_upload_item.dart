
import 'package:file_gallery/upload/item_image_upload.dart';
import 'package:file_gallery/upload/item_office_upload.dart';
import 'package:file_gallery/upload/item_video_upload.dart';
import 'package:file_gallery/util/file_type_util.dart';
import 'package:flutter/material.dart';


class FileUploadItem {

  /// 图片 File或者Url
  dynamic resource;

  /// 附加数据
  dynamic extraData;

  FileUploadItem(
    this.resource,
    {
      this.extraData,
    }
  );

  Widget createItemWidget(ValueChanged<FileUploadItem> deleteCallback, int position) {
    if (FileTypeUtil.isImage(resource)) {
      return ItemImageUpload(resource, deleteCallback: () => deleteCallback(this));
    } else if (FileTypeUtil.isVideo(resource)) {
      return ItemVideoUpload(resource, deleteCallback: () => deleteCallback(this), key: Key(resource.toString()));
    } else if (FileTypeUtil.isOffice(resource)) {
      return ItemOfficeUpload(resource, deleteCallback: () => deleteCallback(this));
    }

    return Container(
      alignment: Alignment.center,
      child: Text('不支持的类型'),
    );
  }

}