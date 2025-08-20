import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_todo/helpers/db_helper.dart';
import 'package:my_todo/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  ///
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Task> _tasks = [];
  List<Task> get tasks => [..._tasks];

  ///
  TextEditingController titleController = TextEditingController();

  /// Loading tasks
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _tasks = await DbHelper.getAllTasks();
      _tasks.sort((a, b) => a.id!.compareTo(b.id!));
      notifyListeners();
    } catch (e) {
      log("Erreur lors du chargement des tâches : $e");
      _tasks = [];
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///
  Future <void> setTaskAsComplete(int index) async {
    _tasks[index].completed = !_tasks[index].completed;
    notifyListeners();
    try {
      await DbHelper.updateData(_tasks[index]);
      notifyListeners();
    } catch (e) {
      log("Erreur lors de la mise à jour: $e");
    }
    notifyListeners();
  }


  /// Creating task
  Future<void> createTask(Task task) async {
    _isLoading = true;
    notifyListeners();
    try {
      final Task createdTask = await DbHelper.insertData(task);
      _tasks.insert(0, createdTask);
      notifyListeners();
    } catch (e) {
      log("❌ Erreur lors de création");
    } finally {
      _isLoading = false;
      titleController.clear();
      notifyListeners();
    }
  }


  /// Remove task
  Future removeTask(int taskId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await DbHelper.deleteData(taskId);
      notifyListeners();
    } catch (e) {
      log("Erreur lors de la suppression: ${e.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Disposer
  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

}