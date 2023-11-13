
import 'package:file_gallery/upload/item_image_upload.dart';
import 'package:file_gallery/upload/item_office_upload.dart';
import 'package:file_gallery/upload/item_video_upload.dart';
import 'package:file_gallery/upload/upload_status/upload_status_controller.dart';
import 'package:file_gallery/util/file_type_util.dart';
import 'package:flutter/material.dart';


class FileUploadItem {

  /// 图片 File或者Url
  dynamic resource;

  /// 附加数据
  dynamic extraData;

  late UploadStatusController statusController;

  FileUploadItem(
    this.resource,
    {
      this.extraData,
    }
  ) {
    statusController = UploadStatusController();
  }

  Widget createItemWidget(Function addFileCallback, ValueChanged<FileUploadItem> deleteCallback, int position) {
    if (FileTypeUtil.isImage(resource)) {
      return ItemImageUpload(
        resource,
        retryingCallback: () {
          addFileCallback.call(resource, this);
        },
        deleteCallback: () => deleteCallback(this),
        statusController: statusController,
      );
    } else if (FileTypeUtil.isVideo(resource)) {
      return ItemVideoUpload(
        resource,
        retryingCallback: () {
          addFileCallback.call(resource, this);
        },
        deleteCallback: () => deleteCallback(this),
        statusController: statusController,
        key: Key(resource.toString()));
    } else if (FileTypeUtil.isOffice(resource)) {
      return ItemOfficeUpload(
        resource,
        retryingCallback: () {
          addFileCallback.call(resource, this);
        },
        deleteCallback: () => deleteCallback(this),
        statusController: statusController,
      );
    }

    return Container(
      alignment: Alignment.center,
      child: Text('不支持的类型'),
    );
  }

}