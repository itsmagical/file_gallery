import 'dart:io';
import 'dart:math';

import 'package:common/util/util.dart';
import 'package:file_gallery/upload/compress/base_compress.dart';
import 'package:file_gallery/upload/file_upload_item.dart';
import 'package:file_gallery/upload/file_upload_share_widget.dart';
import 'package:file_gallery/upload/menu.dart';
import 'package:file_gallery/util/file_type_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

typedef OnAddFileCallback(File file, FileUploadItem item);

typedef OnDeleteFileCallback(FileUploadItem item);

///
/// image，video上传Grid布局
/// 提供选择的File回调 上传操作需在外部实现
/// @author LiuHe
/// @created at 2021/1/29 16:46
class FileUploadGrid extends StatefulWidget {

  FileUploadGrid({
    this.items,
    this.maxCount = 9,
    this.maxAssets = 9,
    this.menus,
    this.viewOnly = false,
    this.compress,
    @required this.addFileCallback,
    @required this.deleteFileCallback,
  });

  /// 在原来的基础上编辑时，已上传的网络数据
  final List<FileUploadItem> items;

  /// 最大上传数量
  final int maxCount;
  /// 每次选择本地资源的最大数量
  /// 不能超过maxCount
  final int maxAssets;
  final List<Menu> menus;
  /// 禁用上传，仅支持查看已上传附件
  final bool viewOnly;
  /// 压缩
  final BaseCompress compress;
  final OnAddFileCallback addFileCallback;
  final OnDeleteFileCallback deleteFileCallback;

  @override
  State<StatefulWidget> createState() {
    return _FileUploadGridState(items, maxCount, this.menus);
  }

}

class _FileUploadGridState extends State<FileUploadGrid> {

  List<CupertinoActionSheetAction> menuActions;
  List<FileUploadItem> items;

  _FileUploadGridState(List<FileUploadItem> items, int maxCount, List<Menu> menus) {
    this.items = Util.isNotNull(items) ? items : [];

    /// 默认拍照和相册
    if (!Util.isNotEmpty(menus)) {
      menus = [Menu.IMAGE, Menu.IMAGE_GALLERY];
    }
    menuActions = getMenuActions(menus);

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: FileUploadShareWidget(
        viewOnly: widget.viewOnly,
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getCrossAxisCount(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
  //              childAspectRatio: 1.7
          ),
          itemBuilder: (context, position) {
            if (position < items.length) {
              FileUploadItem item = items[position];
              return item.createItemWidget(widget.addFileCallback, removeItemCallback, position);
            } else {
              return createAddImageItemWidget();
            }
          },
          itemCount: getItemCount(),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  int getCrossAxisCount() {
    return widget.maxCount > 1 ? 3 : 1;
  }

  /// item数量
  /// 小于最大上传数量 显示添加图片Item
  int getItemCount() {
    int length = items.length;
    return (!widget.viewOnly && length < widget.maxCount) ? length + 1 : length;
  }

  /// 添加图片Item
  Widget createAddImageItemWidget() {
    return GestureDetector(
      onTap: () {
        showCameraOrGalleryOption();
      },
      child: Container(
        color: Color(0xFFF2F2F2),
        child: Icon(
          Icons.add,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }

  void showCameraOrGalleryOption() {
    FocusScope.of(context).requestFocus(FocusNode());

    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: menuActions,
            cancelButton: CupertinoActionSheetAction(
              child: Text('取消'),
              onPressed: () => Navigator.pop(context, 'Cancel'),
            ),
          );
        }
    );
  }

  /// 菜单
  List<CupertinoActionSheetAction> getMenuActions(List<Menu> menus) {
    List<CupertinoActionSheetAction> menuActions = [];
    menus.forEach((menu) {
      switch(menu) {
        case Menu.IMAGE: {
          menuActions.add(
              CupertinoActionSheetAction(
                child: Text('拍照'),
                onPressed: () => openImageOrGallery(true),
              )
          );
          break;
        }
        case Menu.IMAGE_GALLERY: {
          menuActions.add(
              CupertinoActionSheetAction(
                child: Text('选择图片'),
                onPressed: () => openImageOrGallery(false),
              )
          );
          break;
        }
        case Menu.VIDEO: {
          menuActions.add(
              CupertinoActionSheetAction(
                child: Text('拍视频'),
                onPressed: () => openVideoOrGallery(true),
              )
          );
          break;
        }
        case Menu.VIDEO_GALLERY: {
          menuActions.add(
              CupertinoActionSheetAction(
                child: Text('选择视频'),
                onPressed: () => openVideoOrGallery(false),
              )
          );
          break;
        }
      }

    });
    return menuActions;
  }

  /// 拍照或相册
  openImageOrGallery(bool isCamera) async {
    Navigator.pop(context);

    if (isCamera) {
      File image = await ImagePicker.pickImage(
          source: ImageSource.camera,
      );
      if (Util.isNotNull(image)) {
        addItem(image);
      }
    } else {
      List<AssetEntity> assets = await AssetPicker.pickAssets(
        context,
        maxAssets: getMaxAssets(),
        requestType: RequestType.image
      );

      if (Util.isNotNull(assets)) {
        assets.forEach((asset) async {
          File image = await asset.file;
          addItem(image);
        });
      }
    }
  }

  int getMaxAssets() {
    int length = items.length;
    int maxAssets = widget.maxCount - length;
    return min(maxAssets, widget.maxAssets);
  }

  /// 拍视频或视频相册
  openVideoOrGallery(bool isCamera) async {
    Navigator.pop(context);

    if (isCamera) {
      File video = await ImagePicker.pickVideo(
          source: ImageSource.camera,
          maxDuration: widget.compress?.getVideoDuration()
      );
      if (Util.isNotNull(video)) {
        addItem(video);
      }
    } else {
      List<AssetEntity> assets = await AssetPicker.pickAssets(
          context,
          maxAssets: widget.maxCount,
          requestType: RequestType.video
      );

      if (Util.isNotNull(assets)) {
        assets.forEach((asset) async {
          File video = await asset.file;
          addItem(video);
        });
      }
    }
  }

  /// 添加File
  addItem(File file) async {
    if (widget.compress != null) {
      if (FileTypeUtil.isImage(file)) {
        file = await widget.compress.imageCompress(file);
      }
      if (FileTypeUtil.isVideo(file)) {
        file = await widget.compress.videoCompress(file);
      }
    }
    FileUploadItem item = FileUploadItem(file);
//    items.insert(0, item);
    items.add(item);
    widget.addFileCallback(file, item);

    setState(() {
      if (items.length > widget.maxCount) {
        items.removeLast();
      }
    });
  }

  /// 移除item回调
  void removeItemCallback(FileUploadItem item) {
    removeItem(item);
  }

  /// 移除item
  void removeItem(FileUploadItem item) {
    items.remove(item);
    widget.deleteFileCallback(item);
    setState(() {

    });

  }

}