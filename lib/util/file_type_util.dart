import 'dart:io';

///
/// @author LiuHe
/// @created at 2021/2/2 14:18

class FileTypeUtil {

  /// 过滤 URL 中的 Query 参数（?）与锚点（#）
  static String _cleanPath(dynamic resource) {
    String path = '';
    if (resource is File) {
      path = resource.path;
    } else if (resource is String) {
      path = resource;
    }
    if (path.contains('?')) {
      path = path.split('?').first;
    }
    if (path.contains('#')) {
      path = path.split('#').first;
    }
    return path;
  }

  /// 是否为网络资源
  static bool isNetworkSource(String path) {
    return path.contains('http://') || path.contains('https://');
  }

  /// 是否是图片
  /// @ resource File or Url
  static bool isImage(dynamic resource) {
    String path = _cleanPath(resource);
    int index = path.lastIndexOf('.');
    if (index > 0) {
      String extension = path.substring(index).toLowerCase();
      return extension == '.jpg'
          || extension == '.jpeg'
          || extension == '.png'
          || extension == '.bmp';
    }
    return false;
  }

  /// 是否是视频
  /// @ resource File or Url
  static bool isVideo(dynamic resource) {
    String path = _cleanPath(resource);
    int index = path.lastIndexOf('.');
    if (index > 0) {
      String extension = path.substring(index).toLowerCase();
      return extension == '.mp4'
          || extension == '.rmvb'
          || extension == '.3gp'
          || extension == '.avi';
    }
    return false;
  }

  /// 是否为office文档
  static bool isOffice(dynamic resource) {
    String path = _cleanPath(resource);
    int index = path.lastIndexOf('.');
    if (index > 0) {
      String extension = path.substring(index).toLowerCase();
      return extension == '.docx'
          || extension == '.doc'
          || extension == '.xlsx'
          || extension == '.xls'
          || extension == '.pptx'
          || extension == '.ppt'
          || extension == '.pdf'
          || extension == '.zip'
          || extension == '.txt';
    }
    return false;
  }

  /// 是否为office word文档
  static bool isWord(dynamic resource) {
    String path = _cleanPath(resource);
    int index = path.lastIndexOf('.');
    if (index > 0) {
      String extension = path.substring(index).toLowerCase();
      return extension == '.docx'
          || extension == '.doc';
    }
    return false;
  }

  /// 是否为office Excel文档
  static bool isExcel(dynamic resource) {
    String path = _cleanPath(resource);
    int index = path.lastIndexOf('.');
    if (index > 0) {
      String extension = path.substring(index).toLowerCase();
      return extension == '.xlsx'
          || extension == '.xls';
    }
    return false;
  }

  /// 是否为office PPT文档
  static bool isPPT(dynamic resource) {
    String path = _cleanPath(resource);
    int index = path.lastIndexOf('.');
    if (index > 0) {
      String extension = path.substring(index).toLowerCase();
      return extension == '.pptx'
          || extension == '.ppt';
    }
    return false;
  }

  /// 是否为office pdf文档
  static bool isPDF(dynamic resource) {
    String path = _cleanPath(resource);
    int index = path.lastIndexOf('.');
    if (index > 0) {
      String extension = path.substring(index).toLowerCase();
      return extension == '.pdf';
    }
    return false;
  }

  /// 是否为txt
  static bool isTxt(dynamic resource) {
    String path = _cleanPath(resource);
    int index = path.lastIndexOf('.');
    if (index > 0) {
      String extension = path.substring(index).toLowerCase();
      return extension == '.txt';
    }
    return false;
  }

}