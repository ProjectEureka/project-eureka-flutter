import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EurekaProfileButton extends StatefulWidget {
  final ImagePicker picker;

  EurekaProfileButton({
    @required this.picker,
  });

  @override
  _EurekaProfileButtonState createState() => _EurekaProfileButtonState();
}

class _EurekaProfileButtonState extends State<EurekaProfileButton> {
  String mediaPath = '';
  PickedFile _image;

  @override
  void initState() {
    retrieveLostData();
    super.initState();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await widget.picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = response.file;
      });
    } else {
      print(response.exception.code);
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      _image = await widget.picker.getImage(
        source: source,
        imageQuality: 25,
      );
    } catch (e) {
      print(e);
    }

    setState(() {
      mediaPath = _image.path;
    });
    Navigator.pop(context, mediaPath);
  }

  FlatButton cameraFormButtons({
    @required Function onPressed,
    @required IconData icon,
    @required String text,
  }) {
    return FlatButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(
              width: 5.0,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }

  Column _filledMediaPathsAddImageButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cameraFormButtons(
          onPressed: () async => _getImage(ImageSource.camera),
          icon: Icons.camera_alt,
          text: 'Take a New Photo',
        ),
        cameraFormButtons(
          onPressed: () async => _getImage(ImageSource.gallery),
          icon: Icons.photo_library,
          text: 'Pick Photo from Gallery',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _filledMediaPathsAddImageButtons();
  }
}
