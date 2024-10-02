import 'dart:ffi';
import 'dart:io';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:document_scanner/RecognizerScreen.dart';
import 'package:document_scanner/ImageViewScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String>? imagesPath = [];
  bool _isLoading = false;
  late ImagePicker imagePicker;
  List<File> files = [];

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    _loadFiles();
  }

  // Method to get the DCIM ScannedDocuments folder path
  Future<String> _getFolderPath() async {
    Directory? dcimDir = await getExternalStorageDirectory();
    String folderPath = '${dcimDir!.parent.parent.parent.parent.path}/DCIM/ScannedDocuments';

    // Create the folder if it doesn't exist
    if (!await Directory(folderPath).exists()) {
      await Directory(folderPath).create(recursive: true);
    }

    return folderPath;
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

  // Method to load files from the DCIM/ScannedDocuments folder
  Future<void> _loadFiles() async {
    final folderPath = await _getFolderPath();
    final directory = Directory(folderPath);
    final List<FileSystemEntity> entities = directory.listSync();

    // Filter files and sort by last modified date (newest first)
    setState(() {
      files = entities.whereType<File>().toList()
        ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    });
  }

  String timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  Future<void> requestPermission() async{
    if(await Permission.storage.request().isGranted && await Permission.camera.request().isGranted){
      print('success');
    } else {
      print('permission denied');
    }
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
      body: _isLoading ?
      CircularProgressIndicator() :
      Container(
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
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: files.isNotEmpty
                      ? ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      final fileName = file.path.split('/').last;
                      final lastModified = file.lastModifiedSync();

                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Image.file(
                            file,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover, // Display a thumbnail of the image
                          ),
                          title: Text(
                            fileName,
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            timeAgo(lastModified), // Display the time ago
                            style: TextStyle(color: Colors.grey),
                          ),
                          onTap: () {
                            // Navigate to RecognizerScreen with the selected file
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecognizerScreen(file),
                              ),
                            );
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
              onPressed: () async {
                // imagesPath = await CunningDocumentScanner.getPictures(
                //   noOfPages: 1,
                //   isGalleryImportAllowed: true,
                // );
                try {
                  await requestPermission();

                  final List<String>? scannedDocuments = await CunningDocumentScanner.getPictures(
                    isGalleryImportAllowed: true,
                  );
                  if(scannedDocuments != null && scannedDocuments.isNotEmpty){
                    setState(() {
                      _isLoading = true;
                    });
                  }

                  Directory? dcimDir = await getExternalStorageDirectory();
                  String dcimPath = '${dcimDir!.parent.parent.parent.parent.path}/DCIM/ScannedDocuments';

                  Directory(dcimPath).createSync(recursive: true);
                  for(int i = 0; i < scannedDocuments!.length; i++){
                    String fileName = 'scanned_document_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
                    String filePath = '$dcimPath/$fileName';

                    File originalFile = File(scannedDocuments[i]);
                    await originalFile.copy(filePath);
                    print('Document saved at: $filePath');
                  }

                  await _loadFiles();

                  showDialog(context: context, builder: (BuildContext context) => AlertDialog(title:Text('Success'), content: Text('Document have been saved to $dcimPath'),
                      actions:[TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))]
                  ));
                } catch(e){
                  print('Error: $e');
                  showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                    title: Text('Error'),
                    content: Text('Failed to scan or save documents'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'))
                    ],
                  ));
                }finally{
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
                // Handle camera logic
                // _openCamera,
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
