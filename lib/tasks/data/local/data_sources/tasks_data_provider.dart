import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/provider/appwrite_provider.dart';
import 'package:task_manager_app/tasks/data/local/model/task_model.dart';
import 'package:task_manager_app/utils/exception_handler.dart';

import '../../../../utils/constants.dart';

class TaskDataProvider {
  final Databases _databases = Databases(Appwrite.instance.client);

  List<TaskModel> tasks = [];
  SharedPreferences? prefs;

  TaskDataProvider(this.prefs);
  Future<void> createTask(TaskModel taskModel) async {
    try {
      const documentId = 'unique()'; // Generates a unique ID for the document
      final response = await _databases.createDocument(
        databaseId: "66b2fb2c002edaef7e7a",
        collectionId: "66b34cc7002a051b3cea",
        documentId: documentId,
        data: taskModel.toJson(), // Convert your task model to JSON
      );
      print('Task created: ${response.$id}');
    } catch (exception) {
      throw Exception(handleException(exception));
    }
  }

  Future<List<TaskModel>> getTasks() async {
    final documentList = await _databases.listDocuments(
      databaseId: "66b2fb2c002edaef7e7a",
      collectionId: "66b34cc7002a051b3cea",
    );

    try {
      final List<String>? savedTasks = prefs!.getStringList(Constants.taskKey);
      List<Map<String, dynamic>> savedData1 = [];

      // Define the list of keys you want to extract
      const keysToExtract = [
        'id',
        'title',
        'description',
        'completed',
        'startDateTime',
        'stopDateTime'
      ];

      // Iterate through each document and add the filtered map to `savedData1`
      documentList.documents!.forEach((document) {
        Map<String, dynamic> filteredData = {};
        keysToExtract.forEach((key) {
          if (document.data!.containsKey(key)) {
            filteredData[key] = document.data[key];
          }
        });
        savedData1.add(filteredData);
      });

      print(savedData1);
      Future<List<TaskModel>> getTasks() async {
        final documentList = await _databases.listDocuments(
          databaseId: "66b2fb2c002edaef7e7a",
          collectionId: "66b34cc7002a051b3cea",
        );

        try {
          // Assuming prefs is a SharedPreferences instance
          final List<String>? savedTasks =
              prefs!.getStringList(Constants.taskKey);
          List<Map<String, dynamic>> savedData1 = [];

          // Define the list of keys you want to extract
          const keysToExtract = [
            'id',
            'title',
            'description',
            'completed',
            'startDateTime',
            'stopDateTime'
          ];

          // Iterate through each document and add the filtered map to `savedData1`
          documentList.documents!.forEach((document) {
            Map<String, dynamic> filteredData = {};
            keysToExtract.forEach((key) {
              if (document.data!.containsKey(key)) {
                filteredData[key] = document.data![key];
              }
            });

            // Add default value for id if it's missing
            if (!filteredData.containsKey('id')) {
              filteredData['id'] = 'default-id'; // or generate a unique id
            }

            savedData1.add(filteredData);
          });

          print(savedData1);
          print("res");

          // Convert savedData1 to a list of TaskModel
          List<TaskModel> tasks = savedData1
              .map((taskJson) => TaskModel.fromJson(taskJson))
              .toList();
          print(tasks);

          // Sort tasks based on their completion status
          tasks.sort((a, b) {
            if (a.completed == b.completed) {
              return 0;
            } else if (a.completed) {
              return 1;
            } else {
              return -1;
            }
          });

          return tasks;
        } catch (e) {
          throw Exception(handleException(e));
        }
      }

      print("res");

      // if (savedTasks != null) {
      tasks =
          savedData1!.map((taskJson) => TaskModel.fromJson(taskJson)).toList();
      print(tasks);
      tasks.sort((a, b) {
        if (a.completed == b.completed) {
          return 0;
        } else if (a.completed) {
          return 1;
        } else {
          return -1;
        }
      });
      // }
      return tasks;
    } catch (e) {
      throw Exception(handleException(e));
    }
  }
  // Future<List<TaskModel>> getTasks() async {
  //   try {
  //     final List<String>? savedTasks = prefs!.getStringList(Constants.taskKey);
  //     if (savedTasks != null) {
  //       tasks = savedTasks
  //           .map((taskJson) => TaskModel.fromJson(json.decode(taskJson)))
  //           .toList();
  //       tasks.sort((a, b) {
  //         if (a.completed == b.completed) {
  //           return 0;
  //         } else if (a.completed) {
  //           return 1;
  //         } else {
  //           return -1;
  //         }
  //       });
  //     }
  //     return tasks;
  //   }catch(e){
  //     throw Exception(handleException(e));
  //   }
  // }

  Future<List<TaskModel>> sortTasks(int sortOption) async {
    switch (sortOption) {
      case 0:
        tasks.sort((a, b) {
          // Sort by date
          if (a.startDateTime!.isAfter(b.startDateTime!)) {
            return 1;
          } else if (a.startDateTime!.isBefore(b.startDateTime!)) {
            return -1;
          }
          return 0;
        });
        break;
      case 1:
        //sort by completed tasks
        tasks.sort((a, b) {
          if (!a.completed && b.completed) {
            return 1;
          } else if (a.completed && !b.completed) {
            return -1;
          }
          return 0;
        });
        break;
      case 2:
        //sort by pending tasks
        tasks.sort((a, b) {
          if (a.completed == b.completed) {
            return 0;
          } else if (a.completed) {
            return 1;
          } else {
            return -1;
          }
        });
        break;
    }
    return tasks;
  }

  // Future<void> createTask(TaskModel taskModel) async {
  //   try {
  //     tasks.add(taskModel);
  //     final List<String> taskJsonList =
  //         tasks.map((task) => json.encode(task.toJson())).toList();
  //     await prefs!.setStringList(Constants.taskKey, taskJsonList);
  //   } catch (exception) {
  //     throw Exception(handleException(exception));
  //   }
  // }

  Future<List<TaskModel>> updateTask(TaskModel taskModel) async {
    try {
      tasks[tasks.indexWhere((element) => element.id == taskModel.id)] =
          taskModel;
      tasks.sort((a, b) {
        if (a.completed == b.completed) {
          return 0;
        } else if (a.completed) {
          return 1;
        } else {
          return -1;
        }
      });
      final List<String> taskJsonList =
          tasks.map((task) => json.encode(task.toJson())).toList();
      prefs!.setStringList(Constants.taskKey, taskJsonList);
      return tasks;
    } catch (exception) {
      throw Exception(handleException(exception));
    }
  }

  Future<List<TaskModel>> deleteTask(TaskModel taskModel) async {
    try {
      tasks.remove(taskModel);
      final List<String> taskJsonList =
          tasks.map((task) => json.encode(task.toJson())).toList();
      prefs!.setStringList(Constants.taskKey, taskJsonList);
      return tasks;
    } catch (exception) {
      throw Exception(handleException(exception));
    }
  }

  Future<List<TaskModel>> searchTasks(String keywords) async {
    var searchText = keywords.toLowerCase();
    List<TaskModel> matchedTasked = tasks;
    return matchedTasked.where((task) {
      final titleMatches = task.title.toLowerCase().contains(searchText);
      final descriptionMatches =
          task.description.toLowerCase().contains(searchText);
      return titleMatches || descriptionMatches;
    }).toList();
  }
}
