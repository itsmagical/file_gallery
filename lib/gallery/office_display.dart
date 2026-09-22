
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_gallery/util/file_gallery_util.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


///
/// 预览Office文件
/// @author LiuHe
/// @created at 2021/3/5 10:26

class OfficeDisplay extends StatefulWidget {

  OfficeDisplay.file({
    required File file
  }) : resource = file;

  OfficeDisplay.url({
    required String url
  }) : resource = url;

  final dynamic resource;

  @override
  State<StatefulWidget> createState() {
    return _OfficeDisplayState();
  }

}


class _OfficeDisplayState extends State<OfficeDisplay> {

  /// 加载状态 0 文件存在可以加载, 1 下载中， 2 下载错误 3 文件不存在 4 没有找到打开此文件的应用
  int loadingStatus = 1;

  /// 本地文件路径
  String? filePath;

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  /// 检查存储权限
  void checkPermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      var androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 30) { /// android 11以下请求存储权限
        bool isGranted = await Permission.storage.request().isGranted;
        if (!isGranted) return;
      }
      displayFile();
    } else {
      displayFile();
    }
  }

  /// 判断是否为纯文本类文件（纯文本文件内容较少时可能小于 1KB）
  bool _isTextFile(String filePath) {
    String path = FileGalleryUtil.getFileName(filePath).toLowerCase();
    return path.endsWith('.txt') ||
        path.endsWith('.csv') ||
        path.endsWith('.log') ||
        path.endsWith('.json') ||
        path.endsWith('.xml');
  }

  /// 校验文件是否为需要清理的无效/损坏缓存
  bool _isInvalidCacheFile(File file, int fileSize) {
    if (widget.resource is! String) return false;
    if (_isTextFile(file.path)) {
      // 纯文本文件只判定 0 字节为空文件坏缓存
      return fileSize == 0;
    }
    // Office / PDF 等二进制文档小于 1KB 视为损坏/报错缓存
    return fileSize < 1024;
  }

  /// 预览本地文件，不存在或损坏则下载
  void displayFile() async {
    if (widget.resource is File) {
      File file = widget.resource;
      if (!await file.exists()) {
        setState(() {
          loadingStatus = 3;
        });
        return;
      }
    }
    File file = await getFileFromStorage();
    if (await file.exists()) {
      int fileSize = await file.length();
      // 小于 1KB 且非文本类的网络下载文件，视为损坏缓存并清理重新下载
      if (_isInvalidCacheFile(file, fileSize)) {
        try {
          await file.delete();
        } catch (e) {
          debugPrint('删除损坏缓存文件失败: $e');
        }
        downloadFile(widget.resource, file.path);
        return;
      }

      setState(() {
        loadingStatus = 0;
        filePath = file.path;
        if (filePath != null)
        openFile(filePath!);
      });
    } else {
      if (widget.resource is String) {
        downloadFile(widget.resource, file.path);
      }
    }
  }

  void openFile(String path) async {
    String mimeType = FileGalleryUtil.getFileMimeType(path);
    OpenFile.open(path, type: mimeType).then((result) {
      if (result.type == ResultType.done) {
        Navigator.pop(context);
      } else if (result.type == ResultType.noAppToOpen) {
        setState(() {
          loadingStatus = 4;
        });
      } else if (result.type == ResultType.fileNotFound) {
        setState(() {
          loadingStatus = 3;
        });
      } else {
        setState(() {
          loadingStatus = 5;
        });
      }
    });
  }

  Future<File> getFileFromStorage() async {
    if (widget.resource is File) {
      return widget.resource as File;
    }

    Directory directory = await getStorageDirectory();

    String fileName = FileGalleryUtil.getFileName(widget.resource);

    File file = File('${directory.path}/$fileName');

    return file;
  }

  /// 存储路径
  Future<Directory> getStorageDirectory() {
    return getTemporaryDirectory();
  }

  /// 下载
  void downloadFile(String url, String target) async {
    // Directory directory = await getApplicationDocumentsDirectory();
    Directory directory = await getApplicationSupportDirectory();
    bool isExists = await directory.exists();
    if (!isExists) {
      directory.createSync();
    }
    Dio().download(url, target)
    .then((response) async {
      File file = await getFileFromStorage();
      int fileSize = await file.exists() ? await file.length() : 0;
      if (await file.exists() && !_isInvalidCacheFile(file, fileSize)) {
        loadingStatus = 0;
        filePath = file.path;
        if (filePath != null)
        openFile(filePath!);
      } else {
        // 下载下来的文件属于无效文件，进行清理
        if (await file.exists()) {
          try {
            await file.delete();
          } catch (_) {}
        }
        loadingStatus = 2;
      }
    }).catchError((error) async {
      File file = await getFileFromStorage();
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (_) {}
      }
      loadingStatus = 2;
    }).whenComplete(() {
      if (mounted) {
        setState(() {

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
//    checkPermission();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
//            child: loadingStatus == 0 ? FileReaderView(
//              filePath: filePath,
//            ) : getStatusWidget(loadingStatus),
            child: loadingStatus == 0 ? Container() : getStatusWidget(loadingStatus),
          ),
          Wrap(
            children: <Widget>[
              AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 下载文件状态布局
  Widget getStatusWidget(int status) {
    if (status == 1) {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
        ),
      );
    } else if (status == 2) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          '下载文件错误'
        ),
      );
    } else if (status == 3) {
      return Container(
        alignment: Alignment.center,
        child: Text(
            '文件不存在'
        ),
      );
    } else if (status == 4) {
      return Container(
        alignment: Alignment.center,
        child: Text(
            '请下载安装打开此文件的应用'
        ),
      );
    }
    return Container(
      alignment: Alignment.center,
      child: Text(
          '打开文件错误'
      ),
    );
  }



}