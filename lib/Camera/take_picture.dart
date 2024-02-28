import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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
            height: 206,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
          ),
          Positioned(
            bottom: 0.0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 206,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
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
