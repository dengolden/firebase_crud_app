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
  Future<void> updateTask(String docID, String newTask) {
    return tasks.doc(docID).update({
      'task': newTask,
      'timestamp': Timestamp.now(),
    });
  }

  Future<DocumentSnapshot> getTaskById(String docID) {
    return tasks.doc(docID).get();
  }

  // DELETE
  Future<void> deleteTask(String docID) {
    return tasks.doc(docID).delete();
  }
}
