import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late final TextEditingController _taskNameController =
      TextEditingController();
  late LocalStorageService _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorageService>();
    _taskNameController.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              )
            : TextField(
                textInputAction: TextInputAction.done,
                minLines: 1,
                maxLines: null,
                controller: _taskNameController,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (newValue) {
                  if (newValue.length > 3) {
                    widget.task.name = newValue;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey,
              ),
              color:
                  widget.task.isCompleted ? Colors.green : Colors.transparent,
            ),
            child: Icon(
              Icons.check_outlined,
              color:
                  widget.task.isCompleted ? Colors.white : Colors.transparent,
            ),
          ),
        ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.createdAt),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}
