import 'dart:io';
import 'dart:math';

import 'package:file_gallery/upload/compress/base_compress.dart';
import 'package:file_gallery/util/compress_util.dart';
import 'package:video_compress/video_compress.dart';

class DefaultCompress extends BaseCompress {

  DefaultCompress({
    this.imageMaxSize,
    this.imageQuality,
    this.videoMaxDuration
  }) {
    /// 默认0.5M
   if (imageMaxSize == null) {
     imageMaxSize = 1024 * 1024 * 0.5;
   }
   if (videoMaxDuration == null) {
     videoMaxDuration = Duration(seconds: 10);
   }
  }

  /// 图片压缩后的最大约值，quality < 100 实际值小于最大约值
  double imageMaxSize;
  int imageQuality;
  Duration videoMaxDuration;

  @override
  Future<File> imageCompress(File file) async {
    int length = await file.length();
    int sampleSize;
    if (length < imageMaxSize && imageQuality == null) {
      return file;
    }

    if (length > imageMaxSize) {
      var scaleMultiple = length / imageMaxSize;
      sampleSize = sqrt(scaleMultiple).round();
    }

    return CompressUtil.imageCompress(file: file, sampleSize: sampleSize, quality: imageQuality);
  }

  @override
  Future<File> videoCompress(File file) async {
    var info = await VideoCompress.compressVideo(
      file.absolute.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: true,
    );
    return Future.value(info.file);
  }

  @override
  Duration getVideoDuration() {
    return videoMaxDuration;
  }

}