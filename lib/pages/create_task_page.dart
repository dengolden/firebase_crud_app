import 'dart:io';
import 'package:firebase_crud_app/common/theme.dart';
import 'package:firebase_crud_app/service/firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController _taskController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = Path.basename(image.path);
      TaskSnapshot snapshot =
          await _storage.ref().child('images/$fileName').putFile(image);
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _addTask() async {
    String task = _taskController.text.trim();
    if (task.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a task and select an image.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Upload Gambar dari Storage ke Firestore
    String? imageUrl = await _uploadImage(_image!);

    if (imageUrl != null) {
      await firestoreService.addTask(task, imageUrl);

      _taskController.clear();
      setState(() {
        _image = null;
        _isUploading = false;
      });

      Navigator.pop(context);
    } else {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            height: 0.5,
            color: Color(0xffDCDCDC),
          ),
        ),
        backgroundColor: whiteColor,
        title: Text(
          'Create Task',
          style: boldTextStyle.copyWith(
            color: blackColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 16,
              left: 20,
              right: 20,
            ),
            width: double.infinity,
            height: 140,
            padding: EdgeInsets.only(
              top: 32,
              bottom: 32,
              left: 32,
            ),
            decoration: BoxDecoration(
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 35,
                ),
              ],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Your Task',
                  style: regularTextStyle.copyWith(
                    color: blackColor,
                    fontSize: 18,
                  ),
                ),
                TextField(
                  controller: _taskController,
                  style: regularTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Create your task here...',
                    hintStyle: regularTextStyle.copyWith(
                      color: greyColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _image == null
              ? Text('No image selected.')
              : Image.file(_image!, height: 150),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: 150,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: blueColor,
            ),
            child: TextButton(
              onPressed: _pickImage,
              child: Text(
                'Upload Image',
                style: regularTextStyle.copyWith(
                  color: whiteColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          _isUploading
              ? CircularProgressIndicator()
              : Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  height: 50,
                  decoration: BoxDecoration(
                    color: blueColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: _addTask,
                    child: Text(
                      'Create your Task',
                      style: regularTextStyle.copyWith(
                        color: whiteColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
