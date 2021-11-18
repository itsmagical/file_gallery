
import 'dart:io';

import 'package:common/common.dart';
import 'package:common/network/network.dart';
import 'package:file_gallery/util/file_gallery_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:path_provider/path_provider.dart';


///
/// 预览Office文件
/// @author LiuHe
/// @created at 2021/3/5 10:26

class OfficeDisplay extends StatefulWidget {

  OfficeDisplay.file({
    File file
  }) : resource = file.path;

  OfficeDisplay.url({
    String url
  }) : resource = url;

  final String resource;

  @override
  State<StatefulWidget> createState() {
    return _OfficeDisplayState();
  }

}


class _OfficeDisplayState extends State<OfficeDisplay> {

  /// 加载状态 0 文件存在可以加载, 1 下载中， 2 下载错误
  int loadingStatus = 1;

  /// 本地文件路径
  String filePath;

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  /// 检查存储权限
  void checkPermission() async {
    if (await Permission.storage.request().isGranted) {
      displayFile();
    }
  }

  /// 预览本地文件，不存在则下载
  void displayFile() async {
    File file = await getFileFromStorage();
    if (await file.exists()) {
      setState(() {
        loadingStatus = 0;
        filePath = file.path;
      });
    } else {
      downloadFile(widget.resource, file.path);
    }
  }

  Future<File> getFileFromStorage() async {
    if (widget.resource is File) {
      return widget.resource as File;
    }

    Directory directory = await getApplicationDocumentsDirectory();

    String fileName = FileGalleryUtil.getFileName(widget.resource);

    File file = File('${directory.path}/$fileName');

    return file;
  }

  /// 下载
  void downloadFile(String url, String target) async {
    Directory directory = await getApplicationDocumentsDirectory();
    bool isExists = await directory.exists();
    if (!isExists) {
      directory.createSync();
    }
    Network(baseUrl: '').dio.download(url, target)
    .then((response) async {
      File file = await getFileFromStorage();
      if (await file.exists()) {
        loadingStatus = 0;
        filePath = file.path;
      } else {
        loadingStatus = 2;
      }
    }).catchError((error) {
      loadingStatus = 2;
    }).whenComplete(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    checkPermission();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: loadingStatus == 0 ? FileReaderView(
              filePath: filePath,
            ) : getStatusWidget(loadingStatus),
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
    }
    return Container(
      alignment: Alignment.center,
      child: Text(
          '打开文件错误'
      ),
    );
  }



}