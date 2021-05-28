import 'dart:io';

class FileGalleryUtil {

  /// 根据File or url获取文件名
  static String getFileName(dynamic resource) {

    String path = '';

    if (resource is File) {
      path = resource.path;
    }

    if (resource is String) {
      path = resource;
      int index = path.lastIndexOf('/');
      if (index > 0) {
        return path.substring(index + 1);
      }
    }

    return path;
  }

}