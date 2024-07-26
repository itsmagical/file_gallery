

import 'dart:io';

///
///
/// @author LiuHe
/// @created at 2021/2/2 14:18

class FileTypeUtil {


  /// 是否为网络资源
  static bool isNetworkSource(String path) {
    return path.contains('http://') || path.contains('https://');
  }

  /// 是否是图片
  /// @ resource File or Url
  static bool isImage(dynamic resource) {

    if (resource is File) {
      resource = resource.path;
    }

    if (resource is String) {

      int index = resource.lastIndexOf('.');
      if (index > 0) {
        String extension = resource.substring(index);
        return extension == '.jpg'
            || extension == '.jpeg'
            || extension == '.png'
            || extension == '.bmp';
      }
    }

    return false;
  }

  /// 是否是视频
  /// @ resource File or Url
  static bool isVideo(dynamic resource) {

    if (resource is File) {
      resource = resource.path;
    }

    if (resource is String) {

      int index = resource.lastIndexOf('.');
      if (index > 0) {
        String extension = resource.substring(index);
        return extension == '.mp4'
            || extension == '.rmvb'
            || extension == '.3gp'
            || extension == '.avi';
      }
    }

    return false;
  }

  /// 是否为office文档
  static bool isOffice(dynamic resource) {
    if (resource is File) {
      resource = resource.path;
    }

    if (resource is String) {
      int index = resource.lastIndexOf('.');
      if (index > 0) {
        String extension = resource.substring(index);
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
    }

    return false;
  }

  /// 是否为office word文档
  static bool isWord(dynamic resource) {
    if (resource is File) {
      resource = resource.path;
    }

    if (resource is String) {
      int index = resource.lastIndexOf('.');
      if (index > 0) {
        String extension = resource.substring(index);
        return extension == '.docx'
            || extension == '.doc';
      }
    }

    return false;
  }

  /// 是否为office Excel文档
  static bool isExcel(dynamic resource) {
    if (resource is File) {
      resource = resource.path;
    }

    if (resource is String) {
      int index = resource.lastIndexOf('.');
      if (index > 0) {
        String extension = resource.substring(index);
        return extension == '.xlsx'
            || extension == '.xls';
      }
    }

    return false;
  }

  /// 是否为office PPT文档
  static bool isPPT(dynamic resource) {
    if (resource is File) {
      resource = resource.path;
    }

    if (resource is String) {
      int index = resource.lastIndexOf('.');
      if (index > 0) {
        String extension = resource.substring(index);
        return extension == '.pptx'
            || extension == '.ppt';
      }
    }

    return false;
  }

  /// 是否为office pdf文档
  static bool isPDF(dynamic resource) {
    if (resource is File) {
      resource = resource.path;
    }

    if (resource is String) {
      int index = resource.lastIndexOf('.');
      if (index > 0) {
        String extension = resource.substring(index);
        return extension == '.pdf';
      }
    }

    return false;
  }

  /// 是否为txt
  static bool isTxt(dynamic resource) {
    if (resource is File) {
      resource = resource.path;
    }

    if (resource is String) {
      int index = resource.lastIndexOf('.');
      if (index > 0) {
        String extension = resource.substring(index);
        return extension == '.txt';
      }
    }

    return false;
  }

}