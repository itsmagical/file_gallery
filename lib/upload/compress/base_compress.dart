import 'dart:io';

/// 上传压缩，自定义压缩可继承这个类
abstract class BaseCompress {

  Future<File> imageCompress(File file) async {
    return Future.value(file);
  }

  Future<File> videoCompress(File file) async {
    return Future.value(file);
  }

  Duration getVideoDuration() {
    return Duration(seconds: 10);
  }

}