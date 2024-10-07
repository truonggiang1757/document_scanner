import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String score = ""; // API returned score
  String results = "";

  doTextRecognition() async {
    // InputImage inputImage = InputImage.fromFile(this.widget.image);
    // final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    //
    // results = recognizedText.text;
    // print(results);
    // setState(() {
    //   results;
    // });
    // for (TextBlock block in recognizedText.blocks) {
    //   final Rect rect = block.boundingBox;
    //   final List<Point<int>> cornerPoints = block.cornerPoints;
    //   final String text = block.text;
    //   final List<String> languages = block.recognizedLanguages;
    //
    //   for (TextLine line in block.lines) {
    //     // Same getters as TextBlock
    //     for (TextElement element in line.elements) {
    //       // Same getters as TextBlock
    //     }
    //   }
    // }
  }

  // Function to upload recognized text to API
  Future<void> uploadToAPI() async {
    // Replace with your API URL
    final uri = Uri.parse("http://10.0.2.2:5000/upload");

    // Prepare the request
    var request = http.MultipartRequest('POST', uri);

    // Attach the image file as a multipart form data
    var pic = await http.MultipartFile.fromPath("file", widget.image.path);
    request.files.add(pic);

    // Send the request to the API
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      // Set the score received from the API in the UI
      setState(() {
        score = 'Score: ${jsonResponse['overall_score']}';
      });
    } else {
      setState(() {
        score = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Recognizer'),
        actions: [
          // 3-dot menu for upload option
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'Upload') {
                uploadToAPI(); // Call the function to upload
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Upload',
                child: Text('Upload to API'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(widget.image), // Display selected image
            Card(
              margin: EdgeInsets.all(10),
              color: Colors.grey.shade300,
              child: Column(
                children: [
                  // Result section
                  Container(
                    color: Colors.blueAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.document_scanner, color: Colors.white),
                          Text(
                            'Result',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Icon(Icons.copy, color: Colors.white),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                  ),
                  // Display recognized text or score
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      score.isNotEmpty ? score : results,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
