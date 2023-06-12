import 'package:file_gallery/upload/upload_status/upload_status.dart';
import 'package:flutter/cupertino.dart';

class UploadStatusController {

  ValueChanged<UploadStatus> _statusMethod;

  UploadStatus _uploadStatus;

  void setLoading() {
    _setStatus(UploadStatus.LOADING);
  }

  void setError() {
    _setStatus(UploadStatus.ERROR);
  }

  void setFinish() {
    _setStatus(UploadStatus.FINISH);
  }

  _setStatus(UploadStatus status) {
    _uploadStatus = status;
    if (_statusMethod != null) {
      _statusMethod.call(status);
    }
  }

  UploadStatus getUploadStatus() {
    return _uploadStatus;
  }

  void setUploadStatusMethod(ValueChanged<UploadStatus> statusMethod) {
    this._statusMethod = statusMethod;
  }

}