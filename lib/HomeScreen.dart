import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:document_scanner/RecognizerScreen.dart';
import 'package:document_scanner/ImageViewScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImagePicker imagePicker;
  List<File> files = [];

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    _loadFiles();
  }

  // Method to get the application's document directory and create a folder
  Future<String> _getFolderPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final folderPath = Directory('${directory.path}/MyAppFiles');
    if (!await folderPath.exists()) {
      await folderPath.create(recursive: true);
    }
    return folderPath.path;
  }

  // Method to store the picked image in the created folder
  Future<void> _saveImageToFile(XFile xfile) async {
    final folderPath = await _getFolderPath();
    final fileName = xfile.name;
    final savedImage = File('${folderPath}/$fileName');

    // Copy the picked image to the folder
    await File(xfile.path).copy(savedImage.path);

    // Refresh the list of files
    _loadFiles();
  }

  // Method to load files from the folder
  Future<void> _loadFiles() async {
    final folderPath = await _getFolderPath();
    final directory = Directory(folderPath);
    final List<FileSystemEntity> entities = directory.listSync();

    setState(() {
      files = entities.whereType<File>().toList();
    });
  }

  // Method to open the camera and capture an image
  Future<void> _openCamera() async {
    XFile? capturedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (capturedImage != null) {
      File image = File(capturedImage.path);

      // Navigate to the image view screen to show the captured image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewScreen(image: image),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Scanner'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              color: Colors.blueAccent,
              child: Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.scanner,
                            size: 25,
                            color: Colors.white,
                          ),
                          Text(
                            'Scan',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                    InkWell(
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.document_scanner,
                            size: 25,
                            color: Colors.white,
                          ),
                          Text(
                            'Recognize',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                    InkWell(
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_sharp,
                            size: 25,
                            color: Colors.white,
                          ),
                          Text(
                            'Enhance',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      onTap: () {},
                    )
                  ],
                ),
              ),
            ),
            // The list of files in the middle section
            Expanded(
              child: Card(
                color: Colors.black,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: files.isNotEmpty
                      ? ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Icon(
                            Icons.insert_drive_file,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            files[index].path.split('/').last,
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            // Add your file opening logic here
                            print('Opening ${files[index].path}');
                          },
                        ),
                      );
                    },
                  )
                      : Center(
                    child: Text(
                      'No files available',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.rotate_left, color: Colors.white, size: 35),
              onPressed: () {
                // Handle rotation logic
              },
            ),
            IconButton(
              icon: Icon(Icons.camera, color: Colors.white, size: 50),
              onPressed:
                // Handle camera logic
                _openCamera,
            ),
            IconButton(
              icon: Icon(Icons.image_outlined, color: Colors.white, size: 35),
              onPressed: () async {
                XFile? xfile = await imagePicker.pickImage(
                    source: ImageSource.gallery);
                if (xfile != null) {
                  await _saveImageToFile(xfile);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) {
                        return RecognizerScreen(File(xfile.path));
                      }));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
