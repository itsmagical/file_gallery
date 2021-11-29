import 'package:file_gallery/video_player/video_player_control.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoShareWidget extends InheritedWidget {

  VideoShareWidget({
    @required this.child,
    @required this.controlKey,
    @required this.controller
  });

  final Widget child;
  final GlobalKey<VideoPlayerControlState> controlKey;
  final VideoPlayerController controller;

  static VideoShareWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoShareWidget>();
  }

  @override
  bool updateShouldNotify(VideoShareWidget oldWidget) {
    return controller != oldWidget.controller;
  }

}