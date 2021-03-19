import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_eureka_flutter/components/eureka_image_viewer.dart';

class EurekaCameraForm extends StatefulWidget {
  final List<String> mediaPaths;
  final ImagePicker picker;

  EurekaCameraForm({
    @required this.mediaPaths,
    @required this.picker,
  });

  @override
  _EurekaCameraFormState createState() => _EurekaCameraFormState();
}

class _EurekaCameraFormState extends State<EurekaCameraForm> {
  PickedFile _image;

  @override
  void initState() {
    retrieveLostData();
    super.initState();
  }

  /// Android sometimes will crash when the picker is finished
  /// This will retreive that lost data to prevent crash
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

  /// Using image_picker package, you will need to pass in the source of
  /// the image (camera or gallery)
  Future<void> _getImage(ImageSource source) async {
    try {
      await Permission.photos.request();
      PermissionStatus galleyPermissionStatus = await Permission.photos.status;
      PermissionStatus cameraPermissionStatus = await Permission.camera.status;

      if (galleyPermissionStatus.isGranted &&
          cameraPermissionStatus.isGranted) {
        _image = await widget.picker.getImage(
          source: source,
          imageQuality: 25,
        );
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      widget.mediaPaths.add(_image.path);
    });
  }

  /// Camera buttons that lets users add new images, will resize to fit
  /// the proper form
  FlatButton cameraFormButtons({
    @required Function onPressed,
    @required IconData icon,
    @required String text,
  }) {
    bool isEmpty = widget.mediaPaths.length > 0;

    return FlatButton(
      onPressed: onPressed,
      child: Padding(
        padding:
            isEmpty ? const EdgeInsets.all(0.0) : const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(
              width: isEmpty ? 5.0 : 10.0,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: isEmpty ? 12.0 : 16.0,
                fontWeight: isEmpty ? FontWeight.normal : FontWeight.bold,
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

  /// These are the smaller buttons that will show along side a grid of image
  /// preview. This will only show if the user already have taken a picture.
  Row _filledMediaPathsAddImageButtons() {
    return Row(
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

  /// This allows users to open an image fullscreen to preview
  /// and zoom their image.
  void _fullScreenImagePreview(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EurekaImageViewer(imagePath: widget.mediaPaths[index]),
      ),
    );
  }

  /// These are the smaller image previews in the grid, you can tap on the
  /// image to expand into a full screen view.
  Container _showImagePreview(int index) {
    return Container(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.file(
          File(
            widget.mediaPaths[index],
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// This will allow users to remove images they've added.
  Align _removeImageButton(int index) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.mediaPaths.remove(widget.mediaPaths[index]);
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            Icons.remove_circle,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  /// This creates the grid view of images.
  Container _filledMediaPathsGridView() {
    return Container(
      height: MediaQuery.of(context).size.height - 335.0,
      child: GridView.builder(
        itemCount: widget.mediaPaths.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _fullScreenImagePreview(index),
            child: Stack(
              children: [
                _showImagePreview(index),
                _removeImageButton(index),
              ],
            ),
          );
        },
      ),
    );
  }

  /// This is how the screen will change to when there is an image
  /// added by the user
  Column _filledMediaPathsForm() {
    return Column(
      children: [
        _filledMediaPathsAddImageButtons(),
        SizedBox(
          height: 20.0,
        ),
        _filledMediaPathsGridView(),
      ],
    );
  }

  /// This is how the screen will change to when there is no images
  /// added.
  Container _emptyMediaPathsForm() {
    return Container(
      height: MediaQuery.of(context).size.height - 300.0,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
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
        ),
      ),
    );
  }

  /// This will check to see if images are added or not
  Center _cameraForm() {
    return Center(
      child: widget.mediaPaths.length > 0
          ? _filledMediaPathsForm()
          : _emptyMediaPathsForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _cameraForm();
  }
}
