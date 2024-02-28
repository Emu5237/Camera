import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pop/Camera/select_photo.dart';
import 'package:pop/Camera/take_picture.dart';

class SetPhotoScreen extends StatefulWidget {
  const SetPhotoScreen({super.key});

  static const id = 'set_photo_screen';

  @override
  State<SetPhotoScreen> createState() => _SetPhotoScreenState();
}

class _SetPhotoScreenState extends State<SetPhotoScreen> {
  //Front

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (source == ImageSource.camera) {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      final imageFile = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TakePictureScreen(
          camera: firstCamera,
        ),
      ));
      if (imageFile != null) {
        File? img = File(imageFile.path);
        img = await _cropImage(imageFile: img);
        setState(() {
          _image = img;
        });
        Navigator.of(context).pop();
      }
    } else if (source == ImageSource.gallery) {
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        File? img = File(image.path);
        img = await _cropImage(imageFile: img);
        setState(() {
          _image = img;
        });
        Navigator.of(context).pop();
      }
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio4x3,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            hideBottomControls: true),
        IOSUiSettings(
          title: 'Crop Image',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }

  //Back
  File? _image1;
  Future _pickImage1(ImageSource source) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (source == ImageSource.camera) {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      final imageFile = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TakePictureScreen(
          camera: firstCamera,
        ),
      ));
      if (imageFile != null) {
        File? img = File(imageFile.path);
        img = await _cropImage(imageFile: img);
        setState(() {
          _image1 = img;
        });
        Navigator.of(context).pop();
      }
    } else if (source == ImageSource.gallery) {
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File? img = File(image.path);
        img = await _cropImage(imageFile: img);
        setState(() {
          _image1 = img;
        });
        Navigator.of(context).pop();
      }
    }
  }

  void _showSelectPhotoOptions1(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage1,
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Front Side',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _showSelectPhotoOptions(context);
                    },
                    child: Center(
                      child: Container(
                          height: 200.0,
                          width: 500.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey.shade200,
                          ),
                          child: Center(
                            child: _image1 == null
                                ? const Text(
                                    'No image selected',
                                    style: TextStyle(fontSize: 20),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(_image1!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          )),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    child: Text('Select'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => _showSelectPhotoOptions1(context),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Back Side',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _showSelectPhotoOptions1(context);
                    },
                    child: Center(
                      child: Container(
                          height: 200.0,
                          width: 500.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey.shade200,
                          ),
                          child: Center(
                            child: _image == null
                                ? const Text(
                                    'No image selected',
                                    style: TextStyle(fontSize: 20),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(_image!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          )),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    child: Text('Select'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => _showSelectPhotoOptions(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
