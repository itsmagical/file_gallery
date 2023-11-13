import 'package:flutter/material.dart';

class FileUploadShareWidget extends InheritedWidget {

  FileUploadShareWidget({
    required Widget child,
    this.viewOnly,
  }) : super(child: child);

  final bool? viewOnly;

  static FileUploadShareWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FileUploadShareWidget>()!;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

}