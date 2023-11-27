import 'package:hive/hive.dart';
import 'package:to_do_app/models/task_model.dart';

abstract class LocalStorageService {
  Future<void> addTask({required Task task});

  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}

class HiveLocalStorage extends LocalStorageService {
  late Box<Task> _taskBox;
  HiveLocalStorage() {
    _taskBox = Hive.box<Task>('tasks');
  }
  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> allTask = [];
    allTask = _taskBox.values.toList();
    if (allTask.isNotEmpty) {
      allTask.sort(
        (Task a, Task b) {
          return a.createdAt.compareTo(b.createdAt);
        },
      );
    }
    return allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    await task.save();
    return task;
  }
}
