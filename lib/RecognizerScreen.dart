import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RecognizerScreen extends StatefulWidget {
  File image;
  RecognizerScreen(this.image);

  @override
  State<RecognizerScreen> createState() => _RecognizerScreenState();
}

class _RecognizerScreenState extends State<RecognizerScreen> {

  late TextRecognizer textRecognizer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    doTextRecognition();
  }

  String results = "";

  doTextRecognition() async {
    InputImage inputImage = InputImage.fromFile(this.widget.image);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    results = recognizedText.text;
    print(results);
    setState(() {
      results;
    });
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent, title: Text('Recognizer'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(this.widget.image),
            Card(margin: EdgeInsets.all(10), color:Colors.grey.shade300,
                child: Column(
              children: [
                Container(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Icon(Icons.document_scanner, color: Colors.white,),
                    Text('Result', style: TextStyle(color: Colors.white, fontSize: 18),),
                    Icon(Icons.copy, color: Colors.white,)
                  ], mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                ), color: Colors.blueAccent,),
                Text(results, style: TextStyle(fontSize: 18),)
              ],
            ))
          ],
        )
      ),
    );
  }
}
