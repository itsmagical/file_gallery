import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class CompressUtil {

  static Future<File> imageCompress({File file, String targetPath, int minWidth, int minHeight, int sampleSize, int quality}) async {

    if (targetPath == null) {
      Directory directory = await getApplicationDocumentsDirectory();
      bool isExists = await directory.exists();
      if (!isExists) {
        directory.createSync();
      }
      var path = file.path;
      var index = path.lastIndexOf('/');
      var name = path.substring(index, path.length);
      targetPath = directory.absolute.path + name;
    }

    return await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
//      minWidth: minWidth ?? 1920,
//      minHeight: minHeight ?? 1080,
      inSampleSize: sampleSize ?? 1,
      quality: quality ?? 95,
    );
  }

}