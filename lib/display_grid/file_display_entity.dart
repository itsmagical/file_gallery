/// 预览grid数据源实体类
class FileDisplayEntity {

  FileDisplayEntity({
    this.resource,
    this.fileName
  });

  /// url or file
  dynamic resource;

  /// 文件名称
  /// null 则截取resource路径的文件名
  String fileName;

}