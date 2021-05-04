import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// This class allows the users to view an image in full screen
/// and zoom around.
class EurekaImageViewer extends StatelessWidget {
  final String imagePath;
  final bool isUrl;

  const EurekaImageViewer({
    this.imagePath,
    this.isUrl = false,
  });

  @override
  Widget build(BuildContext context) {
    File file = File(imagePath);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              icon: Icon(
                Icons.cancel_rounded,
                color: Colors.cyan,
                size: 35,
              ),
              onPressed: () => Navigator.pop(context)),
          SizedBox(width: 25)
        ],
      ),
      body: PhotoView(
        imageProvider: isUrl ? NetworkImage(imagePath) : FileImage(file),
      ),
    );
  }
}
