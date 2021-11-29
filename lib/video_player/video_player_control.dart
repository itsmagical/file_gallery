import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:file_gallery/images/file_gallery_images.dart';
import 'package:file_gallery/video_player/video_share_widget.dart';
import 'package:file_gallery/video_player/video_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';


/// 视频播放器 控制层widget
/// @author LiuHe
/// @created at 2021/3/2 9:26

class VideoPlayerControl extends StatefulWidget {

  VideoPlayerControl({
    Key key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoPlayerControlState();
  }

}

class VideoPlayerControlState extends State<VideoPlayerControl> {

  /// 播放按钮是否可见
  bool playButtonVisible = true;

  VideoPlayerController get _controller => VideoShareWidget.of(context).controller;

  Timer timer;

  /// 是否已经播放完毕
  bool _isPlayed;

  /// 播放进度
  double progressValue = 0;

  /// 是否拖动进度条
  bool isDragSlider = false;

  /// 是否为全屏
  bool get _isFullScreen => MediaQuery.of(context).orientation == Orientation.landscape;

  Future playListener() async {
    Duration position = await _controller.position;
    Duration duration = _controller.value.duration;
    if (duration == null) return;
    if (position >= duration) {
      if (!_isPlayed) {
        _isPlayed = true;
        /// 移除监听
//        _controller.removeListener(_playListener);
        debugPrint('play finished');
        await _controller.seekTo(Duration.zero);
        await _controller.pause();
        debugPrint('reset...');
        /// 添加监听
//        _controller.addListener(_playListener);
        debugPrint('------addListener');
        showPlayButton();
        progressValue = 0;
      }
    }

    /// 进度条拖动时 不刷新进度
    if (isDragSlider) { return; }

    if (_controller.value.isPlaying) {
      Duration valuePosition = _controller.value.position;
      int positionMilliseconds = valuePosition.inMilliseconds;
      int durationMilliseconds = duration.inMilliseconds;
      if (positionMilliseconds > durationMilliseconds) {
        positionMilliseconds = durationMilliseconds;
      }
      double percent = positionMilliseconds / durationMilliseconds;
      progressValue = percent * 100;
      setState(() {

      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: GestureDetector(
              onDoubleTap: () async {
                await playOrPause();
                if (_controller.value.isPlaying) {
                  showPlayButton(isDelayDismiss: true);
                } else {
                  showPlayButton();
                }
              },
              onTap: () {
                if (_controller == null || !_controller.value.isPlaying) {
                  return;
                }

                showPlayButton(isDelayDismiss: true);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                alignment: Alignment.center,
                child: Visibility(
                  visible: playButtonVisible,
                  child: Align(
                    child: GestureDetector(
                      onTap: () async {
                        await playOrPause();
                        if (_controller.value.isPlaying) {
                          showPlayButton(isDelayDismiss: true);
                        } else {
                          showPlayButton();
                        }
                      },
                      child: Image.asset(
                        _controller.value.isPlaying
                            ? FileGalleryImages.video_player_pause
                            : FileGalleryImages.video_player_start,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              children: <Widget>[
                /// 播放暂停按钮
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                      showPlayButton();
                    } else {
                      _controller.play();
                      showPlayButton(isDelayDismiss: true);
                    }
                  },
                ),
                /// 进度条
                Expanded(
                  child: Container(
//                        color: Colors.red,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                          inactiveTrackColor: Colors.white,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 8
                          ),
                          overlayShape: RoundSliderOverlayShape(
                              overlayRadius: 8
                          )
                      ),
                      child: Slider(
                        value: progressValue,
                        onChanged: (value) {
                          setState(() {
                            progressValue = value;
                          });
                        },
                        onChangeStart: (value) {
                          isDragSlider = true;
                        },
                        onChangeEnd: (value) {
                          isDragSlider = false;
                          debugPrint('changeEnd');
                          int duration = _controller.value.duration.inMilliseconds;
                          double percent = value / 100;
                          _controller.seekTo(Duration(milliseconds: (percent * duration).toInt()));
                        },
                        min: 0,
                        max: 100,
                      ),
                    ),
                  ),
                ),
                /// 时长
                Container(
                  margin: EdgeInsets.only(left: 6),
                  child: Text(
                    getFormatDuration(),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white
                    ),
                  ),
                ),

                /// 全屏
                IconButton(
                    icon: Icon(
                      _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white,
                    ),
                    onPressed: () {
                      toggleFullscreen();
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future playOrPause() async {
    if (_controller.value.isPlaying) {
      await _controller.pause();
    } else {
      await _controller.play();
      _isPlayed = false;
    }
  }

  /// 显示播放按钮
  /// @param isDelayDismiss 是否延迟隐藏
  void showPlayButton({bool isDelayDismiss}) {
    if (timer != null) {
      timer.cancel();
    }
    setState(() {
      playButtonVisible = true;
    });
    if (isDelayDismiss != null && isDelayDismiss) {

      timer = Timer(
          Duration(seconds: 1),
              () {
            setState(() {
              playButtonVisible = false;
            });
          }
      );
    }
  }

  void toggleFullscreen() {
    if (_isFullScreen) {
      AutoOrientation.portraitAutoMode();
      /// 显示状态栏和底部导航栏
      SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    } else {
      AutoOrientation.landscapeAutoMode();
      /// 隐藏状态栏和底部导航栏
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  String getFormatDuration() {

    Duration duration = _controller.value.duration;

    Duration curPosition = _controller.value.position;

    return VideoUtil.formatDuration(curPosition) + '/' +VideoUtil.formatDuration(duration);

  }

}