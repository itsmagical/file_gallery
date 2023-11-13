import 'dart:io';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:file_gallery/util/file_gallery_util.dart';
import 'package:file_gallery/video_player/video_player_control.dart';
import 'package:file_gallery/video_player/video_share_widget.dart';
import 'package:file_gallery/video_player/video_source_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';


/// 视频播放
/// @author LiuHe
/// @created at 2021/2/3 9:59

class VideoPlayerWidget extends StatefulWidget {

  VideoPlayerWidget.file({
    required File file
  }) : resource = file,
        videoLoadType = VideoLoadType.FILE;

  VideoPlayerWidget.url({
    required String url
  }) : resource = url,
        videoLoadType = VideoLoadType.URL;

  VideoPlayerWidget.asset({
    required String asset
  }) : resource = asset,
        videoLoadType = VideoLoadType.ASSET;

  final VideoLoadType videoLoadType;
  final dynamic resource;

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerWidgetState();
  }

}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {

  GlobalKey<VideoPlayerControlState> _key = GlobalKey<VideoPlayerControlState>();

  VideoPlayerController? _controller;

  bool isInit = false;

  late VoidCallback _playListener;

  /// 是否为全屏
  bool get _isFullScreen => MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    if (oldWidget.resource != widget.resource) {
      init();
    }
    super.didUpdateWidget(oldWidget);
  }

  void init() async {

    if (_controller != null) {
      isInit = false;
      _controller!.removeListener(_playListener);
      await _controller!.dispose();
      setState(() {

      });
    }

    if (widget.videoLoadType == VideoLoadType.FILE) {
      _controller = VideoPlayerController.file(widget.resource);
    } else if (widget.videoLoadType ==  VideoLoadType.URL) {
      _controller = VideoPlayerController.networkUrl(widget.resource);
    } else if (widget.videoLoadType ==  VideoLoadType.ASSET) {
      _controller = VideoPlayerController.asset(widget.resource);
    }
    _playListener = playListener;
    _controller!.addListener(_playListener);
    _controller!.initialize()
        .then((value) {
          setState(() {
            isInit = true;
          });
    });
  }

  void playListener() async {
    if(_controller != null && _controller!.value.isPlaying) {
      await _key.currentState?.playListener();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// 全屏状态下，物理键back 退出全屏
        if (_isFullScreen) {
          setPortraitAutoMode();
          return false;
        }
        return true;
      },
      child: VideoShareWidget(
        controlKey: _key,
        controller: _controller!,
        child: Scaffold(
          body: Container(
            child: isInit ? Stack(
              children: <Widget>[
                Container(
                  color: Color(0xFF333333),
                  child: Center(
                      child: _controller!.value.isInitialized
                          ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                          : Container()
                  ),
                ),
                VideoPlayerControl(
                  key: _key,
                ),
                getAppBar(),
              ],
            ) : Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  color: Color(0xFF333333),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
                getAppBar(),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget getAppBar() {
    return Wrap(children: <Widget>[
      AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            if (_isFullScreen) {
              setPortraitAutoMode();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    ]);
  }

  /// 设置竖屏
  void setPortraitAutoMode() {
    AutoOrientation.portraitAutoMode();
    /// 显示状态栏和底部导航栏
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
    if (FileGalleryUtil.isNotNull(_controller)) {
      _controller!.removeListener(_playListener);
      _controller!.dispose();
    }
    super.dispose();
  }

}