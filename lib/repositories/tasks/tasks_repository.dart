import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/repositories/tasks/abstract_tasks_repository.dart';
import 'package:task_manager/repositories/tasks/models/models.dart';

class FirebaseTaskRepository implements AbstractTasksRepository {
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

@override
Future<List<Task>> getTasks() async {
  final snapshot = await tasksCollection.get();
  return snapshot.docs
      .map((doc) => Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
      .toList();
}

  @override
  Future<Task?> getTaskById(String id) async {
    final doc = await tasksCollection.doc(id).get();
    if (doc.exists) {
      return Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  @override
  Future<void> addTask(Task task) async {
    await tasksCollection.add(task.toMap());
  }

  @override
  Future<void> updateTask(Task task) async {
    await tasksCollection.doc(task.id).update(task.toMap());
  }

  @override
  Future<void> deleteTask(String id) async {
    await tasksCollection.doc(id).delete();
  }
}
