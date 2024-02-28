import 'package:flutter/material.dart';
import 'package:pop/Camera/setphotoscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SetPhotoScreen(),
    );
  }
}
