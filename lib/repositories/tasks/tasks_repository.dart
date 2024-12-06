import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/repositories/tasks/tasks.dart';

class FirebaseTaskRepository implements AbstractTasksRepository {
  String _sanitizeEmail(String email) {
    return email.replaceAll('.', '_').replaceAll('@', '_');
  }

  CollectionReference _getTasksCollection() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User is not authenticated");
    }
    final sanitizedEmail = _sanitizeEmail(user.email!);
    return FirebaseFirestore.instance
        .collection('users')
        .doc(sanitizedEmail)
        .collection('tasks');
  }

  @override
  Future<List<Task>> getTasks(String? filter) async {
    final tasksCollection = _getTasksCollection();
    final snapshot = await tasksCollection.get();
    final taskList = snapshot.docs
        .map((doc) =>
            Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    if (filter != null) {
      switch (filter) {
        case 'name':
          taskList.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'time_left':
          taskList.sort((a, b) => a.endDate
              .difference(DateTime.now())
              .compareTo(b.endDate.difference(DateTime.now())));
          break;
        case 'creation_date':
          taskList.sort((a, b) => a.startDate.compareTo(b.startDate));
          break;
      }
    }
    return taskList;
  }

  @override
  Future<List<Task>> getTasksByStatuses(List<TaskStatus> statuses) async {
    final tasksCollection = _getTasksCollection();
    final snapshot = await tasksCollection.get();
    final taskList = snapshot.docs
        .map((doc) =>
            Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    // Фильтруем задачи по статусу
    return taskList.where((task) => statuses.contains(task.status)).toList();
  }

  @override
  Future<Task?> getTaskById(String id) async {
    final tasksCollection = _getTasksCollection();
    final doc = await tasksCollection.doc(id).get();
    if (doc.exists) {
      return Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  @override
  Future<void> addTask(Task task) async {
    final tasksCollection = _getTasksCollection();
    await tasksCollection.add(task.toMap());
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasksCollection = _getTasksCollection();
    await tasksCollection.doc(task.id).update(task.toMap());
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasksCollection = _getTasksCollection();
    await tasksCollection.doc(id).delete();
  }
}
