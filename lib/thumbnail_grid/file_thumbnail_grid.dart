
import 'package:file_gallery/thumbnail_grid/item_image_thumbnail.dart';
import 'package:file_gallery/thumbnail_grid/item_office_thumbnail.dart';
import 'package:file_gallery/thumbnail_grid/item_video_thumbnail.dart';
import 'package:file_gallery/util/file_type_util.dart';
import 'package:flutter/material.dart';


/// 图片、视频、Office 缩略图grid
/// @author LiuHe
/// @created at 2021/3/3 14:35

class FileThumbnailGrid extends StatefulWidget {

  FileThumbnailGrid({
    this.resources,
    this.columnCount = 4
  });

  /// url or file
  final List<dynamic> resources;

  /// 列数
  final int columnCount;

  @override
  State<StatefulWidget> createState() {
    return _FileThumbnailGridState();
  }

}

class _FileThumbnailGridState extends State<FileThumbnailGrid> {

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
            dynamic resource = widget.resources[index];
            if (FileTypeUtil.isImage(resource)) {
              return ItemImageThumbnail(resource: resource);;
            }

            if (FileTypeUtil.isVideo(resource)) {
              return VideoThumbnailItemWidget(resource: resource);
            }

            if (FileTypeUtil.isOffice(resource)) {
              return ItemOfficeThumbnail(resource: resource);
            }

            return Container(
              alignment: Alignment.center,
              child: Text('不支持的文件类型'),
            );
          },
          itemCount: widget.resources.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
    );
  }

  double getSpacing() {
    return widget.columnCount > 4 ? 6 : 10;
  }


}