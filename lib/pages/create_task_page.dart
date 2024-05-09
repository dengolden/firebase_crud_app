import 'package:firebase_crud_app/common/theme.dart';
import 'package:firebase_crud_app/service/firestore.dart';
import 'package:flutter/material.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController _taskController = TextEditingController();

  void _addTask() async {
    String task = _taskController.text.trim();

    await firestoreService.addTask(task);

    _taskController.clear();

    Navigator.pop(context);
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
                _addTask();
              },
              child: Text(
                'Create Your Task',
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
