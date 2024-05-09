import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud_app/common/theme.dart';
import 'package:firebase_crud_app/service/firestore.dart';
import 'package:flutter/material.dart';

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

  TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    DocumentSnapshot document =
        await firestoreService.getTaskById(widget.docID);
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    _taskController.text = data['task'] ?? '';
  }

  Future<void> _saveChanges() async {
    String newTask = _taskController.text;
    await firestoreService.updateTask(widget.docID, newTask);
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
              color: blackColor,
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
          Container(
            margin: EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
            ),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: blueColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                _saveChanges();
              },
              child: Text(
                'Save your Changes',
                style: regularTextStyle.copyWith(
                  color: whiteColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
