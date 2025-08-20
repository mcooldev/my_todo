import 'dart:developer';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../models/task_model.dart';

class ApiService {
  /// Make it private
  ApiService._private();

  static final ApiService _instance = ApiService._private();

  static ApiService get instance => _instance;

  ///
  final String baseUrl = "https://jsonplaceholder.typicode.com/todos";

  /// Get tasks 'Get method'
  Future getTasks() async {
    List<Task> allTasks = [];
    try {
      final uri = Uri.parse(baseUrl);
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = response.body;
        final List<dynamic> decodedData = convert.jsonDecode(data);
        allTasks = decodedData.map((map) => Task.fromJson(map)).toList();
      }

      ///
      return allTasks;
    } catch (e) {
      log("Error while fetching tasks: ${e.toString()}");
    }
  }

  /// Create task 'Post method'
  Future<void> postTask(Task task) async {
    try {
      final uri = Uri.parse(baseUrl);
      final response = await http.post(
        uri,
        body: convert.jsonEncode(task.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      log(response.statusCode.toString());
    } catch (e) {
      log("❌Erreur lors de la création.");
    }
  }

  /// Update a task at index
  Future updateTask(Task task) async {
    try {
      final uri = Uri.parse("$baseUrl/${task.id}");
      final response = await http.put(
        uri,
        body: convert.jsonEncode(task.toJson()),
        headers: {"Content-Type": "application/json"},
      );

      //
      if (response.statusCode == 200 || response.statusCode == 204) {
        log("🎉✅ Mise à jour de la tâche réussie");
      } else {
        log(
          "Une erreur est survenue: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      log("Erreur lors de la mise à jour: ${e.toString()}");
    }
  }

  /// Delete task 'Delete method'
  Future deleteTask(int index) async {
    try {
      final uri = Uri.parse(
        "https://jsonplaceholder.typicode.com/todos/$index",
      );
      final response = await http.delete(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        log("✅ La tâche a été bien supprimé.");
      }
    } catch (e) {
      log("Une erreur est survenu lors de la suppression: ${e.toString()}");
    }
  }
}
