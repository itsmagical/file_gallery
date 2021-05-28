# file_gallery

## 文件预览package

# 文件上传Grid，内部仅实现选择文件的显示和删除操作，具体上传业务需在外部处理，
# 支持拍照、选择图片、拍视频、选择视频，默认拍照和选择图片选项，也可在menu[]中加入选项。

# 已上传的资源添加进FileUploadGrid，用于再次编辑，
# 且不会调用addFileCallback回调
List<FileUploadItem> items = [];
items.add(FileUploadItem('http://www.xxx.com/xx.png', extraData: attachment));
items.add(FileUploadItem('http://www.xxx.com/xx.mp4', extraData: attachment));

FileUploadGrid(
  menus: [
    Menu.IMAGE,
    Menu.IMAGE_GALLERY,
    Menu.VIDEO,
    Menu.VIDEO_GALLERY
  ],
  items: items,
  addFileCallback: (file, item) {
    // upload ...
  },
  deleteFileCallback: (item) {
    // delete ...
  },
),

# 文件缩略图Grid, 点击item可查看详情
# resources的元素可为url or File
FileThumbnailGrid(
  resources: [
    'http:www/xxx.com/xx.doc',
    'http:www.xxx.com/xx.ppt',
    'http:www.xxx.com/xx.xls',
    'http://112.15.96.5:8989/gmis/view/images/common/logo.png',
    'http://112.15.96.5:8989/gmis/appdata/attachments/antiepidemicReport/202102/13611.docx',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ],
)

# 视频播放器 支持 File、url、asset
VideoPlayerWidget.file(file: resource);
VideoPlayerWidget.url(url: resource);
VideoPlayerWidget.asset(asset: resource);

# 图片展示列表
# 支持File、url、asset
ImageGallery(
  resources: [
    File(path),
    'http:www.xxx.com/xx.png',
  ]
)

# Office文档预览 支持 File、url
OfficeDisplay.file(file: resource);
OfficeDisplay.url(url: resource);
