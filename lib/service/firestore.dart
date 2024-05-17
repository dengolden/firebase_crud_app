import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get collection of tasks
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  // CREATE
  Future<void> addTask(String task, String imageUrl) {
    return tasks.add({
      'task': task,
      'imageUrl': imageUrl,
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
  Future<void> updateTask(String docID, String newTask, String imageUrl) {
    return tasks.doc(docID).update({
      'task': newTask,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.now(),
    });
  }

  // GET DOC BY ID
  Future<DocumentSnapshot> getTaskById(String docID) {
    return tasks.doc(docID).get();
  }

  // DELETE
  Future<void> deleteTask(String docID) {
    return tasks.doc(docID).delete();
  }
}
