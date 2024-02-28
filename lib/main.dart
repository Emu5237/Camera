import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Picker and Cropper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SetPhotoScreen(),
    );
  }
}

// ignore: must_be_immutable
class SetPhotoScreen extends StatefulWidget {
  const SetPhotoScreen({super.key});

  static const id = 'set_photo_screen';

  @override
  State<SetPhotoScreen> createState() => _SetPhotoScreenState();
}

class _SetPhotoScreenState extends State<SetPhotoScreen> {
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
        // Do something with the captured image file
        // For example, crop the image
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
        // CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        //CropAspectRatioPreset.ratio16x9
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
        // Do something with the captured image file
        // For example, crop the image
        File? img = File(imageFile.path);
        img = await _cropImage1(imageFile: img);
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
        img = await _cropImage1(imageFile: img);
        setState(() {
          _image1 = img;
        });
        Navigator.of(context).pop();
      }
    }
  }

  Future<File?> _cropImage1({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        // CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        //CropAspectRatioPreset.ratio16x9
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

class SelectPhotoOptionsScreen extends StatelessWidget {
  final Function(ImageSource source) onTap;
  const SelectPhotoOptionsScreen({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey.shade300,
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -35,
            child: Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(children: [
            SelectPhoto(
              onTap: () => onTap(ImageSource.gallery),
              icon: Icons.image,
              textLabel: 'Gallery',
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'OR',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SelectPhoto(
              onTap: () => onTap(ImageSource.camera),
              icon: Icons.camera_alt_outlined,
              textLabel: 'Camera',
            ),
          ])
        ],
      ),
    );
  }
}

class SelectPhoto extends StatelessWidget {
  final String textLabel;
  final IconData icon;

  final void Function()? onTap;

  const SelectPhoto({
    Key? key,
    required this.textLabel,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 10,
        backgroundColor: Colors.grey.shade200,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            const SizedBox(
              width: 14,
            ),
            Text(
              textLabel,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}

main1() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        camera: firstCamera,
      ),
    ),
  );
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture Image')),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_controller),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: Stack(
                  children: [],
                ),
              ),
            ),
          ),
          Container(
            width: 380,
            height: 200,
            decoration: BoxDecoration(
                // border: Border.all(
                //   color: Colors.white,
                //   width: 2.0,
                // ),
                color: Colors.white.withOpacity(0.7)),
          ),
          Positioned(
            bottom: 20.0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.white,
                  //   width: 2.0,
                  // ),
                  color: Colors.white.withOpacity(0.7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        final image = await _controller.takePicture();

                        if (!context.mounted) return;

                        Navigator.of(context).pop(File(image.path));
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Icon(Icons.camera_alt),
                  ),

                  SizedBox(width: 20),
                  // Add spacing between buttons
                  FloatingActionButton(
                    onPressed: () {
                      _toggleFlash();
                    },
                    child: Icon(_flashOn ? Icons.flash_off : Icons.flash_on),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() {
    setState(() {
      _flashOn = !_flashOn;
    });

    if (_flashOn) {
      _controller.setFlashMode(FlashMode.torch);
    } else {
      _controller.setFlashMode(FlashMode.off);
    }
  }
}
