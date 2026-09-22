import 'package:flutter_test/flutter_test.dart';
import 'package:file_gallery/util/file_type_util.dart';
import 'package:file_gallery/util/file_gallery_util.dart';

void main() {
  group('FileTypeUtil tests', () {
    test('Image identification with query parameters and hash anchors', () {
      expect(FileTypeUtil.isImage('http://example.com/image.png?access_token=123'), true);
      expect(FileTypeUtil.isImage('https://example.com/photo.JPG#section'), true);
      expect(FileTypeUtil.isImage('http://example.com/pic.jpeg?token=abc#hash'), true);
      expect(FileTypeUtil.isImage('http://example.com/file.pdf?token=abc'), false);
    });

    test('Office document identification with query parameters', () {
      expect(FileTypeUtil.isOffice('http://example.com/doc.docx?access_token=123'), true);
      expect(FileTypeUtil.isWord('http://example.com/doc.doc?access_token=123'), true);
      expect(FileTypeUtil.isExcel('http://example.com/sheet.xlsx?access_token=123'), true);
      expect(FileTypeUtil.isPPT('http://example.com/slides.pptx?access_token=123'), true);
      expect(FileTypeUtil.isPDF('http://example.com/doc.pdf?access_token=123'), true);
      expect(FileTypeUtil.isTxt('http://example.com/note.txt?access_token=123'), true);
    });

    test('Video identification with query parameters', () {
      expect(FileTypeUtil.isVideo('http://example.com/video.mp4?access_token=123'), true);
    });
  });

  group('FileGalleryUtil tests', () {
    test('getFileName with query parameters and hash anchors', () {
      expect(FileGalleryUtil.getFileName('http://example.com/path/doc.docx?access_token=123#anchor'), 'doc.docx');
    });

    test('getFileMimeType with query parameters and hash anchors', () {
      expect(FileGalleryUtil.getFileMimeType('http://example.com/path/doc.docx?access_token=123#anchor'), 'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
      expect(FileGalleryUtil.getFileMimeType('http://example.com/path/image.png?token=abc'), 'image/png');
    });
  });
}
