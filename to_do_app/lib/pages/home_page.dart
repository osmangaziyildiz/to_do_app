import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/helper/language_helper.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/widgets/search_delegate.dart';
import 'package:to_do_app/widgets/task_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTask = [];
  late LocalStorageService _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorageService>();
    _allTask = [];
    _getAllTaskFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _addTaskToBottomSheet();
          },
          child: const Text('title').tr(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              searchIconButton();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _addTaskToBottomSheet();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTask.isNotEmpty
          ? ListView.builder(
              itemCount: _allTask.length,
              itemBuilder: (BuildContext context, int index) {
                var currentListElement = _allTask[index];
                return Dismissible(
                  resizeDuration: const Duration(seconds: 1),
                  key: Key(currentListElement.id),
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.delete),
                      const SizedBox(width: 5),
                      const Text('remove_task').tr(),
                    ],
                  ),
                  onDismissed: (direction) {
                    _allTask.removeAt(index);
                    _localStorage.deleteTask(task: currentListElement);
                    setState(() {});
                  },
                  child: TaskItem(task: currentListElement),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning),
                  const Text('empty_task_list').tr(),
                ],
              ),
            ),
    );
  }

  void _addTaskToBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 22),
              decoration: InputDecoration(
                  hintText: 'add_task'.tr(), border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.pop(context);
                if (value.length > 3) {
                  DatePicker.showTimePicker(
                    locale: LanguageHelper.getDeviceLanguage(context),
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var newAddingTask =
                          Task.create(name: value, createdAt: time);
                      _allTask.add(newAddingTask);
                      await _localStorage.addTask(task: newAddingTask);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _getAllTaskFromDB() async {
    _allTask = await _localStorage.getAllTask();
    setState(() {});
  }

  searchIconButton() {
    showSearch(
        context: context, delegate: CustomSearchDelegate(allTask: _allTask));
  }
}
