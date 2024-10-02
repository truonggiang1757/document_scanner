import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:image/image.dart' as img;
import 'package:image/src/util/point.dart';

class ImageViewScreen extends StatefulWidget {
  File image;
  ImageViewScreen({required this.image});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  File? processedImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Image"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Image.file(widget.image), // Displays the captured image
      ),
    );
  }
}
