import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';

/// This class allows the users to view an image in full screen
/// and zoom around.
class EurekaImageViewer extends StatelessWidget {
  final String imagePath;
  final bool isUrl;

  const EurekaImageViewer({
    this.imagePath,
    this.isUrl,
  });

  @override
  Widget build(BuildContext context) {
    File file = File(imagePath);
    return Scaffold(
      appBar: EurekaAppBar(
        title: 'Image Preview',
        appBar: AppBar(),
      ),
      body: PhotoView(
        imageProvider: isUrl ? NetworkImage(imagePath) : FileImage(file),
      ),
    );
  }
}
