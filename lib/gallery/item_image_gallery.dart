
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


/// 
/// @author LiuHe
/// @created at 2021/2/3 18:40

class ItemImageGallery extends StatefulWidget {

  ItemImageGallery.file({
    required File file
  }) : provider = FileImage(file);

  ItemImageGallery.url({
    required String url
  }) : provider = NetworkImage(url);

  ItemImageGallery.asset({
    required String asset
  }) : provider = AssetImage(asset);

  final provider;

  @override
  State<StatefulWidget> createState() {
   return _ItemImageGalleryState();
  }

}

class _ItemImageGalleryState extends State<ItemImageGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PhotoView(
            imageProvider: widget.provider
        ),
      ),
    );
  }

}