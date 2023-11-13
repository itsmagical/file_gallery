import 'package:file_gallery/upload/upload_status/upload_status.dart';
import 'package:file_gallery/upload/upload_status/upload_status_controller.dart';
import 'package:flutter/material.dart';

class UploadStatusWidget extends StatefulWidget {

  UploadStatusWidget({
    required this.child,
    this.retryingCallback,
    this.statusController
  });

  final Widget child;
  final VoidCallback? retryingCallback;
  final UploadStatusController? statusController;

  @override
  State<StatefulWidget> createState() {
    return _UploadStatusWidgetState();
  }

}

class _UploadStatusWidgetState extends State<UploadStatusWidget> {


  UploadStatus? status;

  setUploadStatus(UploadStatus status) {
    setState(() {
      this.status = status;
    });
  }

  @override
  void initState() {
    if (widget.statusController != null) {
      status = widget.statusController?.getUploadStatus();
      widget.statusController!.setUploadStatusMethod(setUploadStatus);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children:_getWidgets(),
      ),
    );
  }

  List<Widget> _getWidgets() {
    List<Widget> widgets = [];
    widgets.add(widget.child);
    if (status != null) {
      widgets.add(_getStatusWidget(status!));
    }
    return widgets;
  }

  Widget _getStatusWidget(UploadStatus status) {
    if (status == UploadStatus.LOADING) {
      return _createLoadingWidget();
    }
    if (status == UploadStatus.ERROR) {
      return _createErrorWidget();
    }
    return Container();
  }

  Widget _createLoadingWidget() {
    return FractionallySizedBox(
      widthFactor: 0.4,
      heightFactor: 0.4,
      child: CircularProgressIndicator(),
    );
  }

  Widget _createErrorWidget() {
    return GestureDetector(
      onTap: () {
        if (widget.retryingCallback != null) {
          widget.retryingCallback!.call();
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color(0x66FFFFFF)
        ),
        child: FractionallySizedBox(
          widthFactor: 0.9,
          heightFactor: 0.9,
          child: Container(
            alignment: Alignment.center,
            child: Text(
                '上传失败，点击重试'
            ),
          ),
        ),
      ),
    );
  }

}

