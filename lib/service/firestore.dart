import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get collection of notes
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  // CREATE
  Future<void> addTask(String task) {
    return tasks.add({
      'task': task,
      'timestamp': Timestamp.now(),
    });
  }

  // READ
  Stream<QuerySnapshot> getTaskStream() {
    final tasksStream =
        tasks.orderBy('timestamp', descending: true).snapshots();
    return tasksStream;
  }

  // UPDATE

  // DELETE
}
