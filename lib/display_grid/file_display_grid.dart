
import 'package:file_gallery/display_grid/file_display_entity.dart';
import 'package:file_gallery/display_grid/item_image_display.dart';
import 'package:file_gallery/display_grid/item_office_display.dart';
import 'package:file_gallery/display_grid/item_video_display.dart';
import 'package:file_gallery/util/file_type_util.dart';
import 'package:flutter/material.dart';


/// 图片、视频、Office 预览grid
/// @author LiuHe
/// @created at 2021/3/3 14:35

class FileDisplayGrid extends StatefulWidget {

  FileDisplayGrid({
    this.entities,
    this.columnCount = 4
  });

  /// url or file
  final List<FileDisplayEntity> entities;

  /// 列数
  final int columnCount;

  @override
  State<StatefulWidget> createState() {
    return _FileDisplayGridState();
  }

}

class _FileDisplayGridState extends State<FileDisplayGrid> {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.columnCount,
            mainAxisSpacing: getSpacing(),
            crossAxisSpacing: getSpacing(),
            childAspectRatio: 0.8
          ),
          itemBuilder: (context, index) {
            var entity = widget.entities[index];
            if (FileTypeUtil.isImage(entity.resource)) {
              return ItemImageDisplay(entity: entity);
            }

            if (FileTypeUtil.isVideo(entity.resource)) {
              return ItemVideoDisplay(entity: entity);
            }

            if (FileTypeUtil.isOffice(entity.resource)) {
              return ItemOfficeDisplay(entity: entity);
            }

            return Container(
              alignment: Alignment.center,
              child: Text('不支持的文件类型'),
            );
          },
          itemCount: widget.entities.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
    );
  }

  double getSpacing() {
    return widget.columnCount > 4 ? 6 : 10;
  }


}