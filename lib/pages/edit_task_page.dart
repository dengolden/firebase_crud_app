import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud_app/common/theme.dart';
import 'package:firebase_crud_app/service/firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class EditTaskPage extends StatefulWidget {
  final String docID;

  const EditTaskPage({
    required this.docID,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  TextEditingController _taskController = TextEditingController();
  File? _image;
  String? _imageUrl;
  final picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    DocumentSnapshot document =
        await firestoreService.getTaskById(widget.docID);
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    setState(() {
      _taskController.text = data['task'] ?? '';
      _imageUrl = data['imageUrl'];
    });
  }

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

  Future<void> _saveChanges() async {
    String newTask = _taskController.text;

    setState(() {
      _isUploading = true;
    });
    String? newImageUrl;
    if (_image != null) {
      newImageUrl = await _uploadImage(_image!);
    }
    await firestoreService.updateTask(
        widget.docID, newTask, newImageUrl ?? _imageUrl ?? '');
    setState(() {
      _isUploading = false;
    });
    Navigator.of(context).pop();
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
          'Edit Task',
          style: boldTextStyle.copyWith(
            color: blackColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              firestoreService.deleteTask(widget.docID);
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.delete,
              size: 30,
              color: Colors.red,
            ),
          ),
        ],
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
                  'Edit Task',
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
                    hintText: 'Edit Your Task Here',
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
              ? _imageUrl == null
                  ? Text('No image selected.')
                  : Image.network(_imageUrl!, height: 150)
              : Image.file(_image!, height: 150),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: blueColor,
            ),
            child: TextButton(
              onPressed: _pickImage,
              child: Text(
                'Edit Image',
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
                  height: 40,
                  decoration: BoxDecoration(
                    color: blueColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: _saveChanges,
                    child: Text(
                      'Save your Changes',
                      style: regularTextStyle.copyWith(
                          color: whiteColor, fontSize: 16),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
