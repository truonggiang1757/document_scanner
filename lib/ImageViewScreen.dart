import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageViewScreen extends StatefulWidget {
  File image;
  File? _transformedImage;
  ImageViewScreen({required this.image});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  
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
