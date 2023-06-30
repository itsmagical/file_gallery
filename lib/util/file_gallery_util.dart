import 'dart:io';

class FileGalleryUtil {

  /// @return true object is not null
  static bool isNotNull(Object value) {
    return null != value;
  }

  /// @return true 集合不为空
  static bool isNotEmpty(Iterable iterable) {
    return null != iterable && iterable.length > 0;
  }

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