import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud_app/common/theme.dart';
import 'package:firebase_crud_app/pages/create_task_page.dart';
import 'package:firebase_crud_app/pages/edit_task_page.dart';
import 'package:firebase_crud_app/service/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: EdgeInsets.only(
          top: 40,
          left: 15,
          right: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Task',
                  style: boldTextStyle.copyWith(
                    color: blackColor,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Friday, 10 May',
                  style: regularTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Container(
              width: 110,
              height: 40,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: highlightBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTaskPage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: blueColor,
                      size: 24,
                    ),
                    Text(
                      'New Task',
                      style: regularTextStyle.copyWith(
                          color: blueColor, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget categoryBar() {
      return Container(
        margin: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'All',
                  style: boldTextStyle.copyWith(
                    color: blueColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 4),
                Container(
                  width: 20,
                  height: 14,
                  decoration: BoxDecoration(
                    color: blueColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      '6',
                      style: regularTextStyle.copyWith(
                          color: whiteColor, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 1,
              height: 14,
              decoration: BoxDecoration(
                color: greyColor,
              ),
            ),
            Row(
              children: [
                Text(
                  'Open',
                  style: regularTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 4),
                Container(
                  width: 20,
                  height: 14,
                  decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      '10',
                      style: regularTextStyle.copyWith(
                          color: whiteColor, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Closed',
                  style: regularTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 4),
                Container(
                  width: 20,
                  height: 14,
                  decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      '12',
                      style: regularTextStyle.copyWith(
                          color: whiteColor, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Archived',
                  style: regularTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 4),
                Container(
                  width: 20,
                  height: 14,
                  decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      '2',
                      style: regularTextStyle.copyWith(
                          color: whiteColor, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget taskBox() {
      final FirestoreService firestoreService = FirestoreService();

      return StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTaskStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List tasksList = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tasksList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = tasksList[index];
                String docID = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String taskTitle = data['task'];
                String taskImage = data['imageUrl'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTaskPage(
                          docID: docID,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 33,
                    ),
                    padding: EdgeInsets.only(
                      top: 21,
                      bottom: 21,
                      left: 19,
                    ),
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 35,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    taskImage,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              taskTitle,
                              style: regularTextStyle.copyWith(
                                color: blackColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Text(
              'Bikin dulu Tugasnya :(',
              style: regularTextStyle.copyWith(
                color: blackColor,
              ),
            );
          }
        },
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            height: 0.5,
            color: Color(0xffDCDCDC),
          ),
        ),
        backgroundColor: whiteColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Messages',
              style: regularTextStyle.copyWith(
                color: greyColor,
                fontSize: 20,
              ),
            ),
            Text(
              'Today\'s task',
              style: boldTextStyle.copyWith(
                color: blackColor,
                fontSize: 20,
              ),
            ),
            Text(
              'Last Activity',
              style: regularTextStyle.copyWith(
                color: greyColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          header(),
          categoryBar(),
          taskBox(),
        ],
      ),
    );
  }
}
